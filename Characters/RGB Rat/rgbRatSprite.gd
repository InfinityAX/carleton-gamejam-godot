extends Sprite2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		set_flip_h(true)
	if Input.is_action_just_pressed("ui_right"):
		set_flip_h(false)
