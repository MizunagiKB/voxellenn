extends RigidBody

var survival_time = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	survival_time -= delta
	
	if survival_time < 0:
		self.queue_free()

