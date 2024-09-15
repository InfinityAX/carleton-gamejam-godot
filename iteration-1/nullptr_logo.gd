extends Sprite2D

var timeCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (modulate.a < 1 and timeCounter < 1):
		modulate.a += (1.0/2.0)*delta
	else:
		if (timeCounter < 1):
			timeCounter += 1.0*delta
		else:
			if (modulate.a > 0):
				modulate.a -= (1.0/2.0)*delta
