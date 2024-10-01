extends CharacterBody2D

@export var DEBUG = false

const SPEED = 500.0
const DASH_VELOCITY = 1200.0
var dash_cooldown_length = 1
var time_since_dash = 1
var dash_duration = 0.2
var is_dashing:bool = false

func _ready() -> void:
	if DEBUG:
		$Marker.visible = true
	else:
		$Marker.visible = false

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction_x = Input.get_axis("player_move_left", "player_move_right")
	var direction_y = Input.get_axis("player_move_up", "player_move_down")
	var direction = Vector2(direction_x, direction_y)
	
	if Input.is_action_just_pressed("player_dash") and can_dash():
		if direction != Vector2.ZERO:
			#print_debug("Dashing B)")
			is_dashing = true
			time_since_dash = 0
			velocity = direction.normalized() * DASH_VELOCITY

	if not is_dashing:
		velocity = direction * SPEED
	
	if DEBUG:
		$Marker.position = velocity/3
	
	move_and_slide()

func _process(delta: float) -> void:
	if time_since_dash < dash_cooldown_length:
		time_since_dash += delta
		
	if time_since_dash >= dash_duration:
		is_dashing = false
	
func can_dash() -> bool:
	if time_since_dash >= dash_cooldown_length:
		return true
	#print_debug("NO!")
	return false
