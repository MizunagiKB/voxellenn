extends VehicleBody

const E_INTERACT_TYPE = DefInteract.E_INTERACT_TYPE.VEHIGLE


export(float, 1.0, 1000.0) var MAX_ENGINE_FORCE_D
export(float, -1000.0, 1.0) var MAX_ENGINE_FORCE_B
export(float, 0.0, 1.0) var STEERING_RANGE
export(float, 1.0, 1000.0) var MAX_BREAK

var b_enable_light: bool = false
var o_camera = null

var o_avatar_seat_1 = null
var o_avatar_seat_2 = null


func attach_camera(node_camera):
	self.o_camera = node_camera
	self.o_camera.vehicle_cam()
	self.o_camera.active()

func detach_camera():
	var node_camera = self.o_camera
	self.o_camera = null

	return node_camera


func is_active():

	if self.o_camera != null:
		return true

	return false


func _process(delta):

	if self.is_active():

		if self.o_camera != null:
			self.o_camera.update(delta, self)

	if self.o_avatar_seat_1 != null:

		self.o_avatar_seat_1.set_global_transform(
			$ride_pos_seat_1.global_transform
		)

	if self.o_avatar_seat_2 != null:

		self.o_avatar_seat_2.set_global_transform(
			$ride_pos_seat_2.global_transform
		)


func _physics_process(_delta):

	if self.is_active() == true:

		var n_engine = 0
		var n_steering = 0
		var n_break = 0

		if o_avatar_seat_1 != null:
	
			if Input.is_action_pressed("move_F") == true:
				n_engine = MAX_ENGINE_FORCE_D
			if Input.is_action_pressed("move_B") == true:
				n_engine = MAX_ENGINE_FORCE_B
	
			if Input.is_action_pressed("move_L") == true:
				n_steering = +STEERING_RANGE
			if Input.is_action_pressed("move_R") == true:
				n_steering = -STEERING_RANGE
	
			if InputControl.is_action_pressed("action_Break") == true:
				n_break = MAX_BREAK
	
			if InputControl.is_action_just_pressed("action_Light") == true:
				if self.b_enable_light == true:
					$headlight_l.hide()
					$headlight_r.hide()
					# $roomlight.hide()
					self.b_enable_light = false
				else:
					$headlight_l.show()
					$headlight_r.show()
					# $roomlight.show()
					self.b_enable_light = true

	
			set_engine_force(n_engine)
			set_steering(n_steering)
			set_brake(n_break)
