extends Spatial

# http://soundbible.com/1449-P90-Machine-Gun-Fire.html

const CARTRIDGE_SIZE = 50
const FIRE_RATE = 900
const RAPID = FIRE_RATE / 60

var cls_ammo = load("res://node/weapon/ammo_5_7x28.tscn")
var cls_cart = load("res://node/weapon/cart_5_7x28.tscn")

onready var o_chamber = get_node("chamber")
onready var o_muzzle = get_node("muzzle")
onready var o_eject = get_node("ejectionport")

enum {
	E_FIRE_MODE_SINGLE = 1
	E_FIRE_MODE_FULLAUTO = 2
}

var b_trigger_prev = false
var b_trigger_curr = false
var e_fire_mode = E_FIRE_MODE_FULLAUTO
var fire_time = 0
var ammo = CARTRIDGE_SIZE
var mode = 1
var vct_target: Vector3 = Vector3.ZERO


func reload():
	ammo = CARTRIDGE_SIZE


func get_ammo():
	return ammo


func get_mode():
	return e_fire_mode

func set_mode():
	if e_fire_mode == E_FIRE_MODE_SINGLE:
		e_fire_mode = E_FIRE_MODE_FULLAUTO
	else:
		e_fire_mode = E_FIRE_MODE_SINGLE


func fire():

	var o_bullet = cls_ammo.instance()
		
	o_bullet.set_translation(o_chamber.to_global(Vector3.ZERO))

	var vct_fr = o_chamber.to_global(Vector3.ZERO)
	var vct_to = o_muzzle.to_global(Vector3.ZERO)

	o_bullet.vct_dir = (vct_to- vct_fr).normalized()
	
	get_tree().get_root().add_child(o_bullet)


	var o_cart = cls_cart.instance()
	
	o_cart.set_translation(o_eject.to_global(Vector3.ZERO))
	
	get_tree().get_root().add_child(o_cart)

	get_node("audio_fire").play()


func trigger():
	b_trigger_curr = true


func _process(_delta):

	get_node("status/lbl_ammo/ammo").set_text(str(ammo))
	get_node("status/lbl_fire_mode/fire_mode").set_text(str(e_fire_mode))


func _physics_process(delta):

	if b_trigger_curr == true:
		if e_fire_mode == E_FIRE_MODE_SINGLE:
			if ammo > 0:
				if b_trigger_curr != b_trigger_prev:
					fire()
					ammo -= 1
		elif e_fire_mode ==	E_FIRE_MODE_FULLAUTO:
			fire_time -= delta
			if ammo > 0:
				if fire_time < 0:
					fire()
					fire_time += 1.0 / (FIRE_RATE / 60)
					ammo -= 1
	else:
		fire_time = 0.0

	b_trigger_prev = b_trigger_curr
	b_trigger_curr = false


# [EOF]
