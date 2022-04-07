extends RigidBody2D

signal ship_destroyed

var Plasma = preload("res://objects/plasma_sm/PlasmaSm.tscn")
var Explosion = preload("res://effects/Explosion.tscn")

export var color := Color(255, 0, 0)
export var engine_thrust := 500
export var spin_torque := 2000
export var recoil := -200
export var ease_time := 3
export var action_prefix := "player_1_"

onready var sprite := $Sprite
onready var shield := $Shield
onready var zap_audio := $ZapAudio
onready var animation := $ShipAnimation

enum Rot { LEFT = -1, NONE = 0, RIGHT = 1 }

var thrust := Vector2()
var rotation_dir: int = Rot.NONE
var input_buffer: InputBuffer
var actions = ["shield", "thrust", "fire", "brake", "left", "right"]
var is_invincible := false

var collision_layer_backup := 0
var collision_mask_backup := 0
func _ready():
	add_to_group("player_ships")
	sprite.modulate = color


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

	if input_buffer.is_action_pressed("thrust"):
		thrust = transform.x * engine_thrust
	elif input_buffer.is_action_pressed("brake"):
		thrust = transform.x * (-engine_thrust)
	else:
		thrust = Vector2()

	if input_buffer.is_action_pressed("left"):
		rotation_dir = Rot.LEFT
	elif input_buffer.is_action_pressed("right"):
		rotation_dir = Rot.RIGHT
	else:
		rotation_dir = Rot.NONE

	if input_buffer.is_action_just_pressed("fire"):
		var plasma = Plasma.instance()
		zap_audio.pitch_scale = rand_range(0.8, 1.2)
		zap_audio.play()
		plasma.start($Mussle.global_position, rotation)
		get_parent().add_child(plasma)
		apply_central_impulse(transform.x * recoil)

	if thrust.length() > 0:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false



func _physics_process(_delta):
	pass


func _integrate_forces(state: Physics2DDirectBodyState):
	applied_force = thrust
	applied_torque = rotation_dir * spin_torque

	state.transform.origin = Utils.wrap_physics_body(position)
