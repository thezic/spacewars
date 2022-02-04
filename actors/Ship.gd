extends RigidBody2D

signal ship_destroyed

var Plasma = preload("res://objects/plasma_sm/PlasmaSm.tscn")
var Explosion = preload("res://effects/Explosion.tscn")

export var color := Color(255, 0, 0)
export var engine_thrust := 500
export var spin_torque := 2000
export var recoil := -200

export var shield_energy := 100.0
export var shield_reload := 20.0
export var shield_deplete := 200.0

enum Rot { LEFT = -1, NONE = 0, RIGHT = 1 }

var thrust := Vector2()
var rotation_dir: int = Rot.NONE

var is_shielded := false setget _readonly_setter
var remaining_shield_energy := shield_energy
var shield_depleted := false


onready var sprite := $Sprite
onready var shield_node = $Shield/Node2D
onready var shield_sprite = $Shield/Node2D/ShieldSprite
onready var shield_energy_meter = $Shield/Node2D/ShieldEnergyMeter
onready var shield_collider = $ShieldCollisionShape


func _readonly_setter(_value):
	pass


func _ready():
	sprite.modulate = color
	set_shielded(false)


func start(pos: Vector2):
	position = pos


func set_shielded(value: bool) -> void:
	if value == is_shielded:
		return

	is_shielded = value

	shield_sprite.visible = is_shielded
	shield_collider.disabled = !is_shielded


func try_activate_shield():
	if shield_depleted:
		return
	set_shielded(true)


func deactivate_shield():
	set_shielded(false)


func hit(_damage, _normal: Vector2):
	if is_shielded:
		return

	queue_free()
	var explosion = Explosion.instance()
	explosion.start(position, Vector2())
	get_parent().add_child(explosion)

	emit_signal("ship_destroyed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("player_1_shield"):
		try_activate_shield()

	if Input.is_action_just_released("player_1_shield"):
		deactivate_shield()

	if Input.is_action_pressed("player_1_thrust"):
		thrust = transform.x * engine_thrust
	elif Input.is_action_pressed("player_1_brake"):
		thrust = transform.x * (-engine_thrust)
	else:
		thrust = Vector2()

	if Input.is_action_pressed("player_1_left"):
		rotation_dir = Rot.LEFT
	elif Input.is_action_pressed("player_1_right"):
		rotation_dir = Rot.RIGHT
	else:
		rotation_dir = Rot.NONE

	if Input.is_action_just_pressed("player_1_fire"):
		var plasma = Plasma.instance()
		plasma.start($Mussle.global_position, rotation)
		get_parent().add_child(plasma)
		apply_central_impulse(transform.x * recoil)

	if thrust.length() > 0:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false

	shield_node.position = position

	if is_shielded:
		remaining_shield_energy -= delta * shield_deplete
		shield_energy_meter.value = 100 * remaining_shield_energy / shield_energy
	elif remaining_shield_energy < shield_energy:
		remaining_shield_energy += delta * shield_reload
		shield_energy_meter.value = 100 * remaining_shield_energy / shield_energy
	else:
		shield_depleted = false

	if remaining_shield_energy <= 0:
		shield_depleted = true
		set_shielded(false)


func _physics_process(_delta):
	pass


func _integrate_forces(state: Physics2DDirectBodyState):
	applied_force = thrust
	applied_torque = rotation_dir * spin_torque

	state.transform.origin = Utils.wrap_physics_body(position)
