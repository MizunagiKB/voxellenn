extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	$Control/OptionButton.add_item("08:00", 0)
	$Control/OptionButton.add_item("16:00", 1)
	$Control/OptionButton.add_item("24:00", 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OptionButton_item_selected(id):
	
	if id == 0:
		$DirectionalLight.light_energy = 1.0
		$WorldEnvironment.environment.background_energy = 1.0
	elif id == 1:
		$DirectionalLight.light_energy = 1.0
		$WorldEnvironment.environment.background_energy = 0.2
	else:
		$DirectionalLight.light_energy = 0.0
		$WorldEnvironment.environment.background_energy = 0.01


# [EOF]
