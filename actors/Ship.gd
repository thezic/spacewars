extends RigidBody2D

signal ship_destroyed
signal pickup(pickup)

var Explosion = preload("res://effects/Explosion.tscn")

export var color := Color(255, 0, 0)
export var engine_thrust := 500
export var spin_torque := 2000
export var ease_time := 3
export var action_prefix := "player_1_"
export var use_alternative_controls := true

onready var sprite := $Sprite
onready var shield := $Shield
onready var animation := $ShipAnimation
onready var muzzle := $Muzzle

enum Rot { LEFT = -1, NONE = 0, RIGHT = 1 }

var weapon
var thrust := Vector2()
var rotation_dir: int = Rot.NONE
var alt_control = Vector2.ZERO
var alt_rotation = 0.0
var input_buffer: InputBuffer
var actions = ["shield", "thrust", "fire", "brake", "left", "right", "change_weapon"]
var is_invincible := false

var collision_layer_backup := 0
var collision_mask_backup := 0
func _ready():
	add_to_group("player_ships")
	sprite.modulate = color
	use_alternative_controls = not Settings.classic_controls

	weapon = get_node('Weapon')
	weapon.initialize(get_parent(), muzzle, self)


func mount_weapon(Weapon: PackedScene, stats):
	if weapon:
		weapon.queue_free()
	weapon = Weapon.instance()
	add_child(weapon)
	weapon.initialize(get_parent(), muzzle, self)
	
	print('hello' + str(stats))
	if stats and weapon.has_method('set_stats'):
		weapon.set_stats(stats)
	
	if input_buffer and input_buffer.is_action_pressed("fire"):
		weapon.fire_just_pressed()
	


func start(pos: Vector2, invincible: bool = true):
	position = pos
	if not invincible:
		return

	_set_invincible(true)
	yield(get_tree().create_timer(ease_time), "timeout")
	_set_invincible(false)


func _set_invincible(value: bool):
	is_invincible = value
	if is_invincible:
		collision_layer_backup = collision_layer
		collision_mask_backup = collision_mask
		collision_layer = 0
		collision_mask = 0
		animation.play("flashing")

	else:
		collision_layer = collision_layer_backup
		collision_mask = collision_mask_backup
		animation.stop()



func hit(_damage, _normal: Vector2, _hit_type):
	if is_invincible:
		return

	if shield.is_shielded:
		shield.deplete_shield()
		return

	queue_free()
	var explosion = Explosion.instance()
	explosion.start(position, Vector2())
	get_parent().add_child(explosion)

	emit_signal("ship_destroyed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not input_buffer:
		input_buffer = InputBuffer.new(action_prefix, actions)
	input_buffer.update()

	if input_buffer.is_action_just_pressed("shield"):
		shield.try_activate_shield()

	if input_buffer.is_action_just_released("shield"):
		shield.deactivate_shield()

	alt_control = Vector2.ZERO
	if input_buffer.is_action_pressed("thrust"):
		thrust = transform.x * engine_thrust
		alt_control += Vector2.UP
		# alt_rotation = alt_control.angle()
	elif input_buffer.is_action_pressed("brake"):
		thrust = transform.x * (-engine_thrust)
		alt_control += Vector2.DOWN
		# alt_rotation = alt_control.angle()
	else:
		thrust = Vector2()

	if input_buffer.is_action_pressed("left"):
		rotation_dir = Rot.LEFT
		alt_control += Vector2.LEFT
		# alt_rotation = alt_control.angle()
	elif input_buffer.is_action_pressed("right"):
		rotation_dir = Rot.RIGHT
		alt_control += Vector2.RIGHT
		# alt_rotation = alt_control.angle()
	else:
		rotation_dir = Rot.NONE

	if alt_control.length() > 0:
		alt_rotation = lerp_angle(alt_rotation, alt_control.angle(), _delta * 10)


	if input_buffer.is_action_just_pressed("fire"):
		weapon.fire_just_pressed()

	if input_buffer.is_action_just_released("fire"):
		weapon.fire_just_released()

	if input_buffer.is_action_just_pressed("change_weapon"):
		var parent = get_parent()
		if parent.has_method("get_next_weapon"):
			mount_weapon(parent.get_next_weapon(), parent.get_stats())

	if thrust.length() > 0 or use_alternative_controls and alt_control.length() > 0:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false


func give_pickup(pickup: PickupInfo):
	emit_signal("pickup", pickup)
	return true


func _physics_process(_delta):
	pass


func _alt_control(_state: Physics2DDirectBodyState):
	applied_force = alt_control * engine_thrust
	rotation = alt_rotation


func _integrate_forces(state: Physics2DDirectBodyState):

	if use_alternative_controls:
		_alt_control(state)
	else:
		applied_force = thrust
		applied_torque = rotation_dir * spin_torque

	state.transform.origin = Utils.wrap_physics_body(position)
