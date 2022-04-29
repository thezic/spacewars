extends KinematicBody2D

signal destroyed

export var speed := 200.0
export var success_distance := 50
export var look_ahead := 200.0
export var enable_debug_draw := false
export var damage := 100.0
export var aggressive_distance := 300.0

var destination_target := Vector2.ZERO
var velocity := Vector2.ZERO

var ray_directions = []
var interests = []
var dangers = []
var num_rays = 32
var is_aggressive = false

var chosen_direction := Vector2.ZERO

onready var shield_sprite := $Shield
onready var sprite := $UfoSprite
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


func select_target():
	var player = _find_player()
	if is_aggressive and player:
		return player.position

	var asteroid = _find_asteroid()
	if asteroid:
		return asteroid.position

	return destination_target


func _set_interests():
	var target = select_target()
	var target_direction = (target - position).normalized()

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

	_check_aggressive()
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

	if randf() < 0.8:
		var pickup = Pickups.get_random_pickup(
			[PickupInfo.PickupId.BLASTER_REPEAT, PickupInfo.PickupId.BLASTER_SPREAD],
			[100, 100])
		Pickups.create_pickup(pickup, position, velocity.normalized())

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


func _find_player():
	for player in get_tree().get_nodes_in_group("player_ships"):
		var player_direction = player.position - position
		if player_direction.length() < aggressive_distance:
			return player


func _find_asteroid():
	var asteroids = get_tree().get_nodes_in_group("asteroids")

	if asteroids.size() == 0:
		return null

	var nearest = asteroids[0]
	var distance = (nearest.position - position).length()
	for asteroid in asteroids:
		if (asteroid.position - position).length() < distance:
			nearest = asteroid
			distance = (asteroid.position - position).length()

	return nearest


func sort_asteroid_by_size(a, b):
	return a.size > b.size


func _check_aggressive():
	var player = _find_player()
	if not player:
		is_aggressive = false
		return

	var distance = player.position - position
	is_aggressive = distance.length() < aggressive_distance



func _process(delta):
	var color = sprite.self_modulate
	var target_color = Color(1, 0, 0) if is_aggressive else Color(1, 1, 1)

	sprite.self_modulate = color.linear_interpolate(target_color, delta * 2)
