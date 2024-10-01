extends CharacterBody2D

# Debug flag for visual aids
@export var DEBUG = false

# Character constants
const SPEED = 500.0
const DASH_VELOCITY = 1200.0

# Dash properties
var dash_cooldown_length = 1
var time_since_dash = 1
var dash_duration = 0.2
var is_dashing:bool = false


# Called when the scene enters the tree for the first time
func _ready() -> void:
	if DEBUG:
		$Marker.visible = true
	else:
		$Marker.visible = false


# Fixed-rate physics processing
func _physics_process(delta: float) -> void:
	# Get the input direction.
	var direction_x = Input.get_axis("player_move_left", "player_move_right")
	var direction_y = Input.get_axis("player_move_up", "player_move_down")
	var direction = Vector2(direction_x, direction_y)
	
	# Handle Dash input
	if Input.is_action_just_pressed("player_dash") and can_dash():
		if direction != Vector2.ZERO:
			#print_debug("Dashing B)")
			is_dashing = true
			time_since_dash = 0
			velocity = direction.normalized() * DASH_VELOCITY

	# Apply normal velocity if the player isn't dashing
	if not is_dashing:
		velocity = direction * SPEED if direction != Vector2.ZERO else velocity - velocity/5
	
	# Update marker visual aid
	if DEBUG:
		$Marker.position = velocity/3
	
	# Apply velocity to player body
	move_and_slide()


# Variable rate frame updates
func _process(delta: float) -> void:
	# Update time since player last pressed dash
	if time_since_dash < dash_cooldown_length:
		time_since_dash += delta
	
	# Remove dash state as soon as possible
	if time_since_dash >= dash_duration:
		is_dashing = false


# Check if the player can use their dash
func can_dash() -> bool:
	if time_since_dash >= dash_cooldown_length:
		return true
	#print_debug("NO!")
	return false
