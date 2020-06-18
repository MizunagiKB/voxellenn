extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MAX_ENEMIES = 128
var enemies = 0

var LLENN = null

var mat_damage: SpatialMaterial
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	mat_damage = SpatialMaterial.new()
	mat_damage.albedo_color = Color.red
	mat_damage.flags_unshaded = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
