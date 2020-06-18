extends KinematicBody

const NN_SERVE_HOST = "127.0.0.1"
const NN_SERVE_PORT = 8000


const GRAVITY = 9.8


var hit_time = 1
var b_enable = true
var o_http_client: HTTPClient = null
var vct_move_power = Vector3.ZERO
var vct_direction = Vector3.ZERO
var timer = 1


func data_exc(vct_direction):

	if true:
		var err = self.o_http_client.connect_to_host(NN_SERVE_HOST, NN_SERVE_PORT)
	
		while self.o_http_client.get_status() == HTTPClient.STATUS_CONNECTING or self.o_http_client.get_status() == HTTPClient.STATUS_RESOLVING:
			self.o_http_client.poll()
			OS.delay_msec(1)
	
		var json_data = JSON.print({"x" : vct_direction.x, "y" : vct_direction.y, "z": vct_direction.z})
		var headers = [
			"Content-Type: application/json"
		]
		var e = self.o_http_client.request(HTTPClient.METHOD_POST, "/post_decision", headers, json_data)

		assert(e == OK)
	
		while self.o_http_client.get_status() == HTTPClient.STATUS_REQUESTING:
			self.o_http_client.poll()
			OS.delay_msec(1)
	
		if self.o_http_client.has_response():
			if self.o_http_client.is_response_chunked():
				print("Response is Chunked!")
			else:
				var bl = self.o_http_client.get_response_body_length()
				# print("Response Length: ", bl)

				var data = self.o_http_client.read_response_body_chunk()
#				var raw_data = self.o_http_client.PoolByteArray()
				var dict_data = JSON.parse(data.get_string_from_utf8())

#				print(dict_data.result)

				return Vector3(dict_data.result.x, dict_data.result.y, dict_data.result.z)
				


func _ready():

	self.o_http_client = HTTPClient.new()


func _process(delta):


	if self.b_enable != true:
		self.hit_time -= delta

		$CSGCylinder.material_override = WorkTest.mat_damage
	
		if self.hit_time < 0:
			$CSGCylinder.material_override = null
			self.hit_time = 0.1
			self.b_enable = true

	if self.get_translation().y < -10:
		self.set_translation(Vector3(0, 0, 100))


	#vct_direction = WorkTest.LLENN.get_translation() - self.get_translation()
	#vct_direction = vct_direction.normalized()

	#print(vct_direction)

	#vct_direction = self.data_exc(vct_direction)

	#print(vct_direction)

#	if self.timer < 0:
#		vct_direction.x = randi() % 20 - 10
#		vct_direction.z = randi() % 20 - 10
#		self.timer += 1.0
#	self.timer -= delta


func _physics_process(_delta):

	self.vct_move_power.x = vct_direction.x * 10
	self.vct_move_power.z = vct_direction.z * 10
	self.vct_move_power.y -= GRAVITY

	self.vct_move_power = self.move_and_slide(self.vct_move_power, Vector3.UP)
	

func _on_Area_body_entered(body):
	if body.get_collision_layer_bit(6) == true:
		self.b_enable = false


# [EOF]
