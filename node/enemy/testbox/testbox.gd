extends RigidBody


var b_enable = true
var survival_time = 3


func _ready():
	WorkTest.enemies += 1


func _process(delta):

	if self.b_enable != true:
		survival_time -= delta

		$CSGBox.material_override = WorkTest.mat_damage
	
		if survival_time < 0:
			WorkTest.enemies -= 1
			self.queue_free()

	if self.get_translation().y < -10:
		WorkTest.enemies -= 1
		self.queue_free()


func _on_RigidBody_body_entered(body):
	
	if body.get_collision_layer_bit(6) == true:
		self.b_enable = false


# [EOF]
