extends Node2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		set_position(Vector2i(-89,56))
	if Input.is_action_just_pressed("ui_right"):
		set_position(Vector2i(-11,56))
