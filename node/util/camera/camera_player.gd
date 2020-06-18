extends InterpolatedCamera

var vct_camera_rot = Vector3.ZERO
var vct_camera_forward = Vector3.ZERO
var vct_camera_slide = Vector3.ZERO

var vct_target: Vector3 = Vector3.ZERO

var camera_distance = -1


func vehicle_cam():
	camera_distance = -24

func avatar_cam():
	camera_distance = -8


func active():
	make_current()
	$Listener.make_current()


func update(_delta, o_avatar):

	if Input.is_action_pressed("aim_U") == true:
		vct_camera_rot.x -= 1

	if Input.is_action_pressed("aim_D") == true:
		vct_camera_rot.x += 1

	if Input.is_action_pressed("aim_L") == true:
		vct_camera_rot.y += 2

	if Input.is_action_pressed("aim_R") == true:
		vct_camera_rot.y -= 2

	vct_camera_rot.x = clamp(vct_camera_rot.x, -60, 60)

	var vct_rot = Vector3(0, 0, camera_distance)
	var vct_rot_H = vct_rot.rotated(Vector3.UP, deg2rad(vct_camera_rot.y))


	vct_rot = vct_rot.rotated(Vector3(1, 0, 0), deg2rad(vct_camera_rot.x))
	vct_rot = vct_rot.rotated(Vector3.UP, deg2rad(vct_camera_rot.y))


	set_translation(o_avatar.translation + vct_rot)
	look_at(o_avatar.translation, Vector3.UP)

	$cam.set_translation(o_avatar.translation + vct_rot)
	$cam.look_at(o_avatar.translation, Vector3.UP)


	vct_camera_forward = (Vector3.ZERO - vct_rot_H).normalized()
	vct_camera_slide = vct_camera_forward.cross(Vector3.UP)

	var col = $RayCast.get_collider()
	if col != null:
		self.vct_target = $RayCast.get_collision_point()
		$RayCast/CSGSphere.set_translation($RayCast.to_local(self.vct_target))
		$RayCast/CSGSphere.show()
	else:
		$RayCast/CSGSphere.set_translation($RayCast.get_translation() + Vector3(0, 0, -100))
		self.vct_target = $RayCast/CSGSphere.to_global(Vector3(0, 0, 0))
		$RayCast/CSGSphere.hide()


# [EOF]
