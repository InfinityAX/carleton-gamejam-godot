extends CharacterBody2D


const SPEED = 1200.0
#const JUMP_VELOCITY = -400.0
@export var rgbRatSprite : Sprite2D
@export var rgbRatHitbox : Node2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX := Input.get_axis("ui_left", "ui_right")
	if directionX:
		velocity.x = directionX * SPEED
		if directionX == 1:
			rgbRatSprite.set_flip_h(false)
			rgbRatHitbox.set_position(Vector2i(-11,56))
		elif directionX == -1:
			rgbRatSprite.set_flip_h(true)
			rgbRatHitbox.set_position(Vector2i(-89,56))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var directionY := Input.get_axis("ui_up", "ui_down")
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
