extends Node
class_name Launcher

export var recoil := -200
export var repeate_time := 1.0
export var spread := PI / (2 * 6)
export(AudioStream) var audioStream: AudioStream

export(NodePath) var muzzle_position_path: NodePath
export(NodePath) var world_path: NodePath
export(PackedScene) var projectile_type: PackedScene

var is_fireing := false
var wait_time := 0.0

var extra_projectiles = 0

var owner_body: Node2D
var instances_parent: Node
var muzzle_position: Position2D

onready var zap_audio := $Audio


# Called when the node enters the scene tree for the first time.
func _ready():
	if not muzzle_position:
		muzzle_position = get_node(muzzle_position_path)
	if not instances_parent:
		instances_parent = get_node(world_path)

	if audioStream:
		zap_audio.stream = audioStream

	if owner_body == null:
		owner_body = _find_parent_rigidbody()


func initialize(parent: Node, muzzle: Node2D, ob: Node2D):
	instances_parent = parent
	owner_body = ob
	muzzle_position = muzzle

func set_stats(stats):
	if stats.repeat:
		repeate_time = stats.repeat
	if stats.spread:
		extra_projectiles = stats.spread

func _find_parent_rigidbody():
	var parent = get_parent()
	while parent:
		if parent is RigidBody2D:
			return parent
		parent = parent.get_parent()

	return null


func _process(delta):
	if wait_time > 0:
		wait_time -= delta
		return

	if is_fireing:
		_fire()
		wait_time = repeate_time


func _launch_one(pos, angle):
	var plasma = projectile_type.instance()
	plasma.start(pos, angle)
	instances_parent.add_child(plasma)

func _fire():
	zap_audio.pitch_scale = rand_range(0.8, 1.2)
	zap_audio.play()

	_launch_one(muzzle_position.global_position, muzzle_position.global_rotation)
	for i in extra_projectiles:
		_launch_one(muzzle_position.global_position, muzzle_position.global_rotation + i * spread + rand_range(-PI/10, PI/10))
		_launch_one(muzzle_position.global_position, muzzle_position.global_rotation - i * spread + rand_range(-PI/10, PI/10))

	if owner_body is RigidBody2D:
		owner_body.apply_central_impulse(Vector2.RIGHT.rotated(muzzle_position.global_rotation) * recoil)


func fire_just_pressed():
	_fire()
	is_fireing = true
	wait_time = repeate_time


func fire_just_released():
	is_fireing = false


func fire_pressed(_value: bool):
	pass
