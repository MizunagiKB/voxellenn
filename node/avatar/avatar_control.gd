extends KinematicBody


const GRAVITY = 9.8

export(float, 1.0, 1000.0) var WALK_SPEED
export(float, 1.0, 1000.0) var RUN_SPEED
export(float, 1.0, 1000.0) var JUMP_POWER

var o_camera = null
onready var o_fsm = get_node("fsm_player")

var o_interact_target = null


var equip_weapon = null
var o_attach_interact = null

var vct_move_power: Vector3 = Vector3(0, 0, 0)


func attach_weapon(o_weapon):

	if o_weapon.get_parent():
		o_weapon.get_parent().remove_child(o_weapon)

	get_node("vox/x_b_root/Skeleton/attach_hand_r").add_child(o_weapon)

	self.equip_weapon = o_weapon
	self.equip_weapon.set_translation(Vector3.ZERO)
	self.o_fsm.sense_attach_weapon = true


func detach_weapon():

	assert(false)
	self.o_fsm.sense_attach_weapon = false


func attach_camera(node_camera):

	if self.o_attach_interact == null:
		self.o_camera = node_camera
		self.o_camera.avatar_cam()
		self.o_camera.active()
	else:
		self.o_attach_interact.attach_camera(node_camera)


func detach_camera():
	var node_camera

	if self.o_camera != null:
		node_camera = self.o_camera
	else:
		if self.o_attach_interact != null:
			node_camera = self.o_attach_interact.detach_camera()

	self.o_camera = null

	return node_camera


func is_active():

	if self.o_camera != null:
		return true
	elif self.o_attach_interact != null and self.o_attach_interact.is_active():
		return true

	return false


func _ready():

	get_node("vox/AnimationTree").get("parameters/move/playback").start("idol")


func _process(delta):

	
	if self.is_active():
		if self.o_camera != null:
			self.o_camera.update(delta, self)

		for name in self.o_fsm.order_list_animation:
			if name in ["idol", "walk", "run"]:
				get_node("vox/AnimationTree").get("parameters/move/playback").travel(name)
			elif name == "hold:1":
				get_node("vox/AnimationTree")["parameters/hold/blend_amount"] = 1.0
				$vox/x_b_root/Skeleton/SkeletonIK.start(false)
			elif name == "hold:0":
				get_node("vox/AnimationTree")["parameters/hold/blend_amount"] = 0.0
				$vox/x_b_root/Skeleton/SkeletonIK.stop()

				for n in range($vox/x_b_root/Skeleton/SkeletonIK.get_parent_skeleton().get_bone_count()):
					$vox/x_b_root/Skeleton/SkeletonIK.get_parent_skeleton().set_bone_global_pose_override(n, Transform.IDENTITY, 0)

		if self.o_fsm.order_action_fire:
			if self.equip_weapon != null:
				var v = $vox.to_local(self.o_camera.vct_target)
				$vox/Spatial.set_translation(v)
#				self.equip_weapon.vct_target = self.o_camera.vct_target
				self.equip_weapon.trigger()

		if self.o_fsm.order_action_reload:
			if self.equip_weapon != null:
				self.equip_weapon.reload()

		if self.o_fsm.order_action_interact:
			if self.o_attach_interact == null:
				if self.o_interact_target != null:
					var o_interact = self.o_interact_target
					self.o_fsm.sense_attach_vehicle = self.o_interact_target.attach_avatar(self)
					if self.o_fsm.sense_attach_vehicle == true:
						self.o_attach_interact = o_interact
						self.o_attach_interact.attach_camera(self.detach_camera())
						self.o_fsm.change("state_interact")
					else:
						self.o_fsm.change("state_idol")
			else:
				var o_interact = self.o_attach_interact
				if o_interact.detach_avatar(self) == true:
					self.o_attach_interact = null
					self.attach_camera(o_interact.detach_camera())

					self.o_fsm.sense_attach_vehicle = false
					self.o_fsm.change("state_idol")


func _physics_process(_delta):

	if self.o_camera != null:
		var vct_move = Vector3.ZERO
		vct_move += (self.o_camera.vct_camera_forward * self.o_fsm.order_move.z)
		vct_move += (self.o_camera.vct_camera_slide * self.o_fsm.order_move.x)
		vct_move.normalized()

		if self.o_fsm.order_e_move_mode == self.o_fsm.E_MOVE_MODE.WALK:
			vct_move *= WALK_SPEED
		else:
			vct_move *= RUN_SPEED

		self.vct_move_power = vct_move

		if self.is_on_floor():
			pass
			#if action_jump:
			#	vct_move_power.y += JUMP_POWER
		else:
			vct_move_power.y -= GRAVITY

		self.vct_move_power = self.move_and_slide(self.vct_move_power, Vector3.UP)
		
		if self.o_fsm.order_action_fire:
			self.look_at(self.get_translation() - self.o_camera.vct_camera_forward, Vector3.UP)
		elif vct_move.length() > 0:
			self.look_at(self.get_translation() - vct_move, Vector3.UP)

	var rot = get_rotation()
	rot.x = 0
	rot.z = 0
	self.set_rotation(rot)


func _on_interact_body_entered(body):
	self.o_interact_target = body
	self.o_interact_target.show_interact_info()
	self.o_fsm.sense_e_interact_type = self.o_interact_target.E_INTERACT_TYPE


func _on_interact_body_exited(_body):
	if self.o_interact_target != null:
		self.o_interact_target.hide_interact_info()
	self.o_fsm.sense_e_interact_type = DefInteract.E_INTERACT_TYPE.NONE
	self.o_interact_target = null


# [EOF]
