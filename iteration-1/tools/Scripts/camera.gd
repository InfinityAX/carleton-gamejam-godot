extends Camera2D

@export var target: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move camera to target's position
	position = target.position


# Set a new target for the camera
func set_target(new_target: Node2D):
	target = new_target
