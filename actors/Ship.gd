extends RigidBody2D

signal ship_destroyed

var Plasma = preload("res://objects/plasma_sm/PlasmaSm.tscn")
var Explosion = preload("res://effects/Explosion.tscn")

export var color := Color(255, 0, 0)
export var engine_thrust := 500
export var spin_torque := 2000
export var recoil := -200
export var action_prefix := "player_1_"

onready var sprite := $Sprite
onready var shield := $Shield


enum Rot { LEFT = -1, NONE = 0, RIGHT = 1 }

var thrust := Vector2()
var rotation_dir: int = Rot.NONE
var input_buffer: InputBuffer
var actions = ["shield", "thrust", "fire", "brake", "left", "right"]

func _ready():
	sprite.modulate = color


func start(pos: Vector2):
	position = pos


func hit(_damage, _normal: Vector2):
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
