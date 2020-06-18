extends Node


var o_fsm: CFSMPlayer


func prologue():

	pass


func run_proc(_delta):

	if self.o_fsm.input_action_interact == true:
		self.o_fsm.order_action_interact = true


# [EOF]
