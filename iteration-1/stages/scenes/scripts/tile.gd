class_name Tile 
extends Sprite2D

var neighbors: Array = []
enum DIRECTION {
	RIGHT = 0,
	DOWN = 2,
	LEFT = 4,
	UP = 6
}


func has_free_side():
	for d in DIRECTION:
		if neighbors[DIRECTION[d]] == null:
			return true
	return false


# Adds a tile t as a neighbor to this tile at location dir
# Allows for fast pathfinding and tile group alterations
# Returns true if t was added, and false otherwise
func add_neighbor(t: Tile, dir: DIRECTION) -> bool:
	if has_neighbor(dir):
		return false
	elif neighbors.has(t):
		return false
	else:
		neighbors[dir] = t
		t.add_neighbor(self, (dir +4)%8)
		
		return true


func has_neighbor(i: int):
	return neighbors[i] != null


func get_neighbor(i: int):
	return neighbors[i]


func _init() -> void:
	neighbors.resize(8)
	neighbors.fill(null)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
