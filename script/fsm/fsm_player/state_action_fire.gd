extends Node


var o_fsm: CFSMPlayer


func prologue():
	self.o_fsm.order_list_animation.append("hold:1")


func epilogue():
	self.o_fsm.order_list_animation.append("hold:0")


func run_proc(_delta):

	if self.o_fsm.input_action_fire == true:
		self.o_fsm.order_action_fire = true
	else:
		self.o_fsm.remove_action(self.name)


# [EOF]
