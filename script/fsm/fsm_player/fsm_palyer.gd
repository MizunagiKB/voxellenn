extends Node
class_name CFSMPlayer

const DEBUG: bool = true

enum E_MOVE_MODE {
	WALK = 1,
	RUN = 2
}


var o_state: Object
var dict_state_action = {}

var sense_e_interact_type: int = DefInteract.E_INTERACT_TYPE.NONE
var sense_attach_weapon: bool = false
var sense_attach_vehicle: bool = false

# world to fsm
var input_dir: Vector3 = Vector3.ZERO
var input_e_move_mode: int = E_MOVE_MODE.WALK
var input_action_fire: bool = false
var input_action_reload: bool = false
var input_action_interact: bool = false


# fsm to world
var order_move: Vector3 = Vector3.ZERO
var order_action_fire: bool = false
var order_action_reload: bool = false
var order_action_interact: bool = false
var order_e_move_mode: int = E_MOVE_MODE.WALK
var order_list_animation = []


func change(state_path):
	assert(get_node(state_path))
	if self.o_state.has_method("epilogue"):
		self.o_state.epilogue()
	self.o_state = get_node(state_path)
	self._enter_state()


func append_action(state_path):
	assert(get_node(state_path))

	var o_state_new = get_node(state_path)
	
	if o_state_new.name in self.dict_state_action:
		pass
	else:
		o_state_new.o_fsm = self
		o_state_new.prologue()
		self.dict_state_action[o_state_new.name] = o_state_new


func remove_action(state_path):
	assert(get_node(state_path))

	var o_state_chk = get_node(state_path)
	
	if o_state_chk.name in self.dict_state_action:
		if o_state_chk.has_method("epilogue"):
			o_state_chk.epilogue()
			o_state_chk.o_fsm = null
			self.dict_state_action.erase(o_state_chk.name)


func _enter_state():
	self.o_state.o_fsm = self
	self.o_state.prologue()


func _ready():
	self.o_state = self.get_child(0)
	self._enter_state()


func _process(delta):

	self.input_dir = Vector3.ZERO

	self.order_move = Vector3.ZERO
	self.order_list_animation = []
	self.order_action_fire = false
	self.order_action_reload = false
	self.order_action_interact = false


	if Input.is_action_pressed("move_F") == true:
		self.input_dir.z = 1.0
	if Input.is_action_pressed("move_B") == true:
		self.input_dir.z = -1.0
	if Input.is_action_pressed("move_L") == true:
		self.input_dir.x = -1.0
	if Input.is_action_pressed("move_R") == true:
		self.input_dir.x = 1.0

	if Input.is_action_just_pressed("move_Mode") == true:
		if input_e_move_mode == E_MOVE_MODE.WALK:
			input_e_move_mode = E_MOVE_MODE.RUN
		else:
			input_e_move_mode = E_MOVE_MODE.WALK

	self.input_action_fire = InputControl.is_action_pressed("action_Fire")
	self.input_action_reload = InputControl.is_action_just_pressed("action_Reload")
	self.input_action_interact = InputControl.is_action_just_pressed("action_Interact")
	
	if self.o_state.has_method("run_proc"):
		self.o_state.run_proc(delta)

	for name in self.dict_state_action:
		var o = self.dict_state_action[name]
		if o.has_method("run_proc"):
			o.run_proc(delta)


# [EOF]
