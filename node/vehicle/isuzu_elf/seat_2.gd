extends StaticBody

const E_INTERACT_TYPE = DefInteract.E_INTERACT_TYPE.VEHIGLE


func show_interact_info():
	get_node("../interact_info").show()


func hide_interact_info():
	get_node("../interact_info").hide()


func attach_avatar(o_avatar):

	if self.get_parent().o_avatar_seat_2 == null:
		self.get_parent().o_avatar_seat_2 = o_avatar
		return true
	else:
		return false


func detach_avatar(o_avatar):

	if self.get_parent().o_avatar_seat_1 == o_avatar:
		self.get_parent().o_avatar_seat_1 = null
		return true
	elif self.get_parent().o_avatar_seat_2 == o_avatar:
		self.get_parent().o_avatar_seat_2 = null
		return true
	else:
		return false


func attach_camera(node_camera):
	self.get_parent().attach_camera(node_camera)


func detach_camera():
	return self.get_parent().detach_camera()


func is_active():
	return self.get_parent().is_active()


func _ready():
	pass


# [EOF]
