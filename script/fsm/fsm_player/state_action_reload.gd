extends Node


var o_fsm: CFSMPlayer


func prologue():
	pass


func epilogue():
	pass


func run_proc(_delta):

	if self.o_fsm.input_action_fire == false:
		if self.o_fsm.input_action_reload == true:
			self.o_fsm.order_action_reload = true

	self.o_fsm.remove_action(self.name)


# [EOF]
