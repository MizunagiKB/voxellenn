extends RigidBody

const E_COLLISION_TYPE = DefCollision.E_COLLISION_TYPE.FRIEND_BULLET
const BULLET_SPEED = 71.5

var survival_time = 3
var vct_dir = null


func _ready():
	apply_central_impulse(vct_dir * BULLET_SPEED)

func _process(delta):

	survival_time -= delta
	
	if survival_time < 0:
		self.queue_free()
		set_process(false)

