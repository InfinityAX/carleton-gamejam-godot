extends Sprite2D

var alphaValue = 0
var timeCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = alphaValue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (alphaValue < 1 and timeCounter < 1):
		alphaValue += (1.0/2.0)*delta
	else:
		if (timeCounter < 1):
			timeCounter += 1.0*delta
		else:
			if (alphaValue > 0):
				alphaValue -= (1.0/2.0)*delta
		
	modulate.a = alphaValue
	print(alphaValue)
	print(modulate.a)
