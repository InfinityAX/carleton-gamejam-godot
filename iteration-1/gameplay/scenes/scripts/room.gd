extends Node2D

# Maximum tiles a room can have. TODO: generate this value procedurally
@export var max_sprawl: int = 30

const directions = {
	'vectors' = {
		'right': Vector2.RIGHT,
		'down': Vector2.DOWN,
		'left': Vector2.LEFT,
		'up': Vector2.UP
	},
	'indices' = {
		'right': 0,
		'down': 2,
		'left': 4,
		'up': 6
	}
}

# Preload the tile scene for ease of access
var tile_scene: PackedScene = preload("res://gameplay/scenes/tile.tscn")
var tile_width = 32

# Definition of different rooms sizes
enum BUILD_RADIUS {
	SMALL = 100,
	MEDIUM = 200,
	LARGE = 400
}

# The maximum distance a tile is allowed to be from the build center
var room_size: BUILD_RADIUS

# Angle from the build center to the entrance of the room
var entrance_angle: float
var entrance_tile: Tile = tile_scene.instantiate()
var entrance_position: Vector2

# How difficult the room should be
var difficulty: int
var boundary: Array

# Generate the location of the entrance relative to the build center
func generate_entrance_position() -> void:
	var rand = randf()
	var phase
	if rand < 0.5:
		room_size = BUILD_RADIUS.SMALL
	elif rand < 0.85:
		room_size = BUILD_RADIUS.MEDIUM
	else:
		room_size = BUILD_RADIUS.LARGE
	
	rand = randf()
	if rand < 0.5:
		phase = -1
	else:
		phase = 1
		
	rand = randf()
	entrance_angle = PI*rand*phase
	entrance_position = Vector2.from_angle(entrance_angle)*room_size


func update_entrance_position() -> void:
	entrance_tile.position = entrance_position
	seed_tile_gen()


# Places one or two tiles beside the entrance 
func seed_tile_gen() -> void:
	var seeds = get_nearest_cardinals(entrance_angle + PI)
	
	for s in seeds:
		var new_tile = tile_scene.instantiate()
		var i = directions.vectors.find_key(s)
		$Tiles.add_child(new_tile)
		new_tile.position = entrance_position + get_tile_offset(s)
		entrance_tile.add_neighbor(new_tile, directions.indices[i])
		boundary.append(new_tile)


# Must be called after seed_tile_gen(), as the entrance is not be considered in room generation
func generate_room() -> void:
	if $Tiles.get_child_count() == 0:
		push_error("Room generation was not seeded properly!")
	

# TODO: Add one tile in a random direction, relative to another tile
# Direction is weighted towards the build center
func add_tile() -> void:
	var pos_data = get_valid_tile_position()
	var tile = pos_data[0]
	var dir = pos_data[1]
	var new_tile = tile_scene.instantiate()
	$Tiles.add_child(new_tile)
	new_tile.position = tile.position + get_tile_offset(dir)
	tile.add_neighbor(new_tile, dir)
	boundary.append(new_tile)
	if tile.has_free_side():
		boundary.append(tile)


func _init() -> void:
	generate_entrance_position()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_center = get_viewport_rect().size/2
	position = screen_center
	$Control.position = -screen_center
	
	add_child(entrance_tile)
	update_entrance_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_regenerate_pressed() -> void:
	boundary.clear()
	for t in $Tiles.get_children():
		t.queue_free()
	generate_entrance_position()
	update_entrance_position()


func _on_add_tile_pressed() -> void:
	add_tile()


# Returns the Tile directional index associated with a given unit vector
func get_index_from_vector(v: Vector2) -> int:
	var d = directions.vectors.find_key(v)
	return directions.indices[d]


# Returns the unit vector associated with a given Tile directional index
func get_vector_from_index(i: int) -> Vector2:
	var d = directions.indices.find_key(i)
	return directions.vectors[d]


# Takes an angle a in radians and returns an array containing the closest unit vector(s)
func get_nearest_cardinals(a: float):
	var res: PackedVector2Array
	var cosa = cos(a)
	var sina = sin(a)
	var dirs = {
		"x": Vector2.RIGHT if cosa > 0 else Vector2.LEFT,
		"y": Vector2.DOWN if sina > 0 else Vector2.UP
	}
	
	if absf(cosa) > cos(PI/4):
		res.append(dirs.x)
		if absf(sina) > sin(PI/8):
			res.append(dirs.y)
	else:
		res.append(dirs.y)
		if absf(cosa) > cos(3*PI/8):
			res.append(dirs.x)
	
	return res


# Returns a random unit Vector within ~PI/2 radians of the given angle
func random_direction(a: float) -> Vector2:
	var cards = get_nearest_cardinals(a)
	var rand = randf()
	var dir_to_add: Vector2
	if rand < 0.5:
		dir_to_add = cards[0]
	else:
		dir_to_add = cards[1] if cards.size() == 2 else apply_random_rotation(cards[0])
	return dir_to_add


# Applies a random rotation of PI/2 to a given Vector
func apply_random_rotation(v: Vector2) -> Vector2:
	var dir = get_index_from_vector(v)
	if randf() > 0.5:
		dir = (dir + 2) % 8
	else:
		dir = (dir + 6) % 8
	
	return get_vector_from_index(dir)


# TODO: Debug infinite loop that's happening somewhere in here
# Returns a dictonary containing a valid tile position relative to a random tile
func get_valid_tile_position() -> Array:
	var expand_from: Tile = get_random_boundary_tile()
	var found_valid = false
	var next_dir
	while !found_valid:
		var angle_to_center = expand_from.position.angle() + PI
		next_dir = get_clamped_direction(expand_from, angle_to_center)
		var neighbor = expand_from.get_neighbor(next_dir)
		if neighbor != null:
			continue
		found_valid = true
	return [expand_from, next_dir]


func get_clamped_direction(tile: Tile, a: float):
	var dir = random_direction(a)
	var new_loc: Vector2 = tile.position + get_tile_offset(dir)
	if new_loc.length() > room_size:
		dir = rotate_towards(dir, a)
	return get_index_from_vector(dir)


func get_random_boundary_tile() -> Tile:
	var n = boundary.size()-1
	if n == 0:
		return boundary.pop_back()
	var rand = randi_range(0, n)
	var t = boundary[rand]
	var x = boundary.pop_back()
	boundary[rand] = x
	return t


# Returns the vector representing the position tile_width units away in direction v
func get_tile_offset(v) -> Vector2:
	var res = v
	if v is int:
		res = get_vector_from_index(v)
	return res * tile_width


# Rotates Vector v PI/2 rads towards angle a
func rotate_towards(v: Vector2, a: float) -> Vector2:
	var dir = 1 if v.angle_to(Vector2.from_angle(a)) > 0 else -1
	return v.rotated(PI/2*dir)
