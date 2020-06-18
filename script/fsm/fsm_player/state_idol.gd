extends Node


var o_fsm: CFSMPlayer


func prologue():
	self.o_fsm.order_list_animation.append("idol")


func run_proc(_delta):

	if self.o_fsm.sense_attach_weapon == true:
		if self.o_fsm.input_action_fire == true:
			self.o_fsm.append_action("state_action_fire")

	if self.o_fsm.input_action_reload == true:
		self.o_fsm.append_action("state_action_reload")

	if self.o_fsm.input_action_interact == true:
		if self.o_fsm.sense_e_interact_type == DefInteract.E_INTERACT_TYPE.VEHIGLE:
			self.o_fsm.order_action_interact = true

	if self.o_fsm.input_dir.length() > 0.1:
		if self.o_fsm.input_e_move_mode == self.o_fsm.E_MOVE_MODE.WALK:
			self.o_fsm.change("state_walk")
		else:
			self.o_fsm.change("state_run")


