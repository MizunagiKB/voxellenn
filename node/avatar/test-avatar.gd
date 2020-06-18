extends Spatial


func _ready():

	var o_cam = get_node("camera_player")
	$llenn.attach_camera(o_cam)
	$llenn.attach_weapon(get_node("fn_p90"))

	WorkTest.LLENN = $llenn


func _input(event):
	if event is InputEventKey:

		if event.pressed and event.scancode == KEY_1:
			var o_cam = $fukajiroh.detach_camera()
			if o_cam == null:
				o_cam = get_node("camera_player")
			$llenn.attach_camera(o_cam)

		elif event.pressed and event.scancode == KEY_2:
			var o_cam = $llenn.detach_camera()
			if o_cam == null:
				o_cam = get_node("camera_player")
			$fukajiroh.attach_camera(o_cam)


func _process(_delta):

	$Control/llenn/active.hide()
	$Control/fukajiroh/active.hide()

	$Control/llenn/state.set_text($llenn/fsm_player.o_state.name)
	if $llenn.is_active() == true:
		$Control/llenn/active.show()

	$Control/fukajiroh/state.set_text($fukajiroh/fsm_player.o_state.name)
	if $fukajiroh.is_active() == true:
		$Control/fukajiroh/active.show()


	$HSlider/enemies.set_text(str(int(WorkTest.enemies)))
	$HSlider/max_enemies.set_text(str(int(WorkTest.MAX_ENEMIES)))

	if WorkTest.enemies < WorkTest.MAX_ENEMIES:
		var c = load("res://node/enemy/testbox/testbox.tscn")
		var o = c.instance()

		var vct_position = Vector3(
			randi() % 20 + 0,
			100,
			randi() % 20 + 256
		)

		o.set_translation(vct_position)

		get_tree().get_root().add_child(o)


func _on_HSlider_value_changed(value):
	WorkTest.MAX_ENEMIES = int(value)


# [EOF]
