extends KinematicBody2D

signal destroyed

export var speed := 200.0
export var success_distance := 50
export var look_ahead := 200.0
export var enable_debug_draw := false
export var damage := 100.0

var destination_target := Vector2.ZERO
var velocity := Vector2.ZERO

var ray_directions = []
var interests = []
var dangers = []
var num_rays = 32

var chosen_direction := Vector2.ZERO

onready var shield_sprite := $Shield
onready var timer := $Timer
onready var tween := $Tween
onready var target_area := $TargetArea

var Explosion = preload("res://effects/Explosion.tscn")
var Plasma = preload("res://objects/plasma_sm/PlasmaSm.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ray_directions.resize(num_rays)
	interests.resize(num_rays)
	dangers.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
	_choose_destination()



func start(pos):
	position = pos
	_choose_destination()


func _draw():
	if not enable_debug_draw:
		return

	for i in num_rays:
		draw_line(Vector2.ZERO, ray_directions[i] * interests[i] * 50, Color(255, 255, 0), 1)
		draw_line(Vector2.ZERO, ray_directions[i] * dangers[i] * 50, Color(255, 0, 0), 1)

	draw_line(Vector2.ZERO, chosen_direction * 50, Color(0, 255, 0), 2)


func _choose_destination():
	var nr_destinations = 32
	var all_directions = []
	all_directions.resize(nr_destinations)
	var screensize = get_viewport_rect().size

	if position.x > screensize.x / 2:
		destination_target.x = 0
	else:
		destination_target.x = screensize.x

	destination_target.y = rand_range(0, screensize.y)

	print("Destination:")
	print(destination_target)


func _set_interests():
	var target_direction = (destination_target - position).normalized()

	for player in get_tree().get_nodes_in_group("player_ships"):
		target_direction = player.position - position

	target_direction = target_direction.normalized()
	for i in num_rays:
		var d = ray_directions[i].rotated(rotation).dot(target_direction)
		interests[i] = max(0, d)


func _set_dangers():
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(
			position,
			position + ray_directions[i].rotated(rotation) * look_ahead,
			[self])

		if result:
			var danger_value = (look_ahead - (result.position - position).length()) / look_ahead
			dangers[i] = danger_value
		else:
			dangers[i] = 0.0


func _apply_danger_for_direction(danger_index, danger_value):
	for i in num_rays:
		var d = ray_directions[i].rotated(rotation).dot(ray_directions[danger_index])
		if d < 0:
			interests[i] += -(d * danger_value)


func _choose_direction():
	for i in num_rays:
		if dangers[i] > 0.0:
			_apply_danger_for_direction(i, dangers[i])

	chosen_direction = Vector2.ZERO
	for i in num_rays:
		chosen_direction += ray_directions[i] * interests[i]
	chosen_direction = chosen_direction.normalized()


func _physics_process(delta):
	# var a: Vector2 = position - destination_target
	if (position - destination_target).length() < success_distance:
		_choose_destination()

	_set_interests()
	_set_dangers()
	_choose_direction()

	if enable_debug_draw:
		update()

	var desired_velocity = chosen_direction.rotated(rotation) * speed
	velocity = velocity.linear_interpolate(desired_velocity, 0.05)
	var collision := move_and_collide(velocity * delta, false)
	if collision:
		if collision.collider.has_method('hit'):
			collision.collider.hit(damage, velocity.normalized(), Constants.HitTypes.ufo)


func flash_shield():
	tween.interpolate_property(shield_sprite, "modulate:a", 1.0, 0.0, 0.3)
	tween.start()
	shield_sprite.visible = true
	yield(get_tree().create_timer(1), "timeout")
	shield_sprite.visible = false


func hit(_damage: int, _normal: Vector2, hit_type):
	if hit_type == Constants.HitTypes.asteroid:
		flash_shield()
		return

	destroy()


func destroy(emit = true):
	print("emit signal ufo destroyed")
	var explosion = Explosion.instance()
	get_parent().add_child(explosion)
	explosion.start(position, Vector2())
	if emit:
		emit_signal("destroyed")
	queue_free()


func _on_Timer_timeout():
	# Find target
	var bodys = target_area.get_overlapping_bodies()
	if not bodys:
		return

	var nearest = bodys[0].position - position
	for body in bodys:
		if nearest.length() > (body.position - position).length():
			nearest = body.position - position

	# Fire a bullet
	var plasma = Plasma.instance()
	get_parent().add_child(plasma)
	plasma.start(position, nearest.angle(), Constants.HitTypes.ufo)
	plasma.collision_layer = 1
	plasma.collision_mask = 1
