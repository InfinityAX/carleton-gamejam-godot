extends Sprite2D

var alphaValue:float = 0.0
var timeCounter:float = 0.0
var splashShowDone = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = alphaValue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (splashShowDone):
		if (timeCounter > 2):
			get_tree().change_scene_to_file("res://mainMenu/sceneMainMenu.tscn")
		else:
			timeCounter += 1.0*delta
	else:
		if (alphaValue < 1 and timeCounter < 1):
			alphaValue += (1.0/2.0)*delta
			if (alphaValue > 1):
				alphaValue = 1
		else:
			if (timeCounter < 1):
				timeCounter += 1.0*delta
			else:
				if (alphaValue > 0):
					alphaValue -= (1.0/2.0)*delta
					if (alphaValue < 0):
						alphaValue = 0
						splashShowDone = true
		
		modulate.a = alphaValue
	
	# DEBUG
	# print(modulate.a)
	# print(timeCounter)
