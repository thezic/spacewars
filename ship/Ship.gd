extends RigidBody2D



export var color := Color(255, 0, 0)
export var engine_thrust := 500
export var spin_torque := 2000
export var recoil := -200

enum Rot { LEFT = -1, NONE = 0, RIGHT = 1 }

var thrust := Vector2()
var rotation_dir: int = Rot.NONE
var screensize: Vector2
var Plasma = preload("res://plasma_sm/PlasmaSm.tscn")


func _ready():
	$Sprite.modulate = color
	screensize = get_viewport().get_visible_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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

func _physics_process(_delta):
	pass


func _integrate_forces(state: Physics2DDirectBodyState):
	applied_force = thrust
	applied_torque = rotation_dir * spin_torque

	state.transform.origin = Utils.wrap_physics_body(position)
