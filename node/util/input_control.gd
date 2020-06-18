extends Node


#var input_dir: Vector3 = Vector3.ZERO
var input_action_fire_prev: bool = false
var input_action_fire_curr: bool = false
var input_action_reload_prev: bool = false
var input_action_reload_curr: bool = false
var input_action_interact_prev: bool = false
var input_action_interact_curr: bool = false


class CInputStatus:
	var status_prev: bool = false
	var status_curr: bool = false

	func is_action_pressed():
		return self.status_curr

	func is_action_just_pressed():
		return self.status_curr == true and self.status_curr != self.status_prev

	func run_proc(name: String):
		self.status_prev = self.status_curr
		self.status_curr = Input.is_action_pressed(name)


var dict_input = {
	"action_Fire": CInputStatus.new(),
	"action_Reload": CInputStatus.new(),
	"action_Interact": CInputStatus.new(),
	"action_Break": CInputStatus.new(),
	"action_Light": CInputStatus.new()
}


func is_action_pressed(name: String):
	return dict_input[name].is_action_pressed()

func is_action_just_pressed(name: String):
	return dict_input[name].is_action_just_pressed()


func _ready():
	pass
	

func _process(_delta):
	for k in dict_input:
		dict_input[k].run_proc(k)


# [EOF]
