extends RigidBody2D

signal asteroid_destroyed(size)

export var size := 5
export var max_size := 5
export var split_into := 3
export var base_scale := Vector2(2.0, 2.0)

var on_destroyed_clb: FuncRef

var Asteroid = load("res://objects/asteroid/Asteroid.tscn")
var Explosion = preload("res://effects/Explosion.tscn")

var split_and_speed = {
	5: 100,
	4: 150,
	3: 200,
	2: 225,
	1: 250,
}


func _get_scale() -> float:
	return float(size) / max_size


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("asteroids")
	mass = size
	_fix_scale()


func hit(_damage: int, normal: Vector2):
	destroy()

	var explosion = Explosion.instance()
	explosion.start(position, Vector2())
	get_parent().add_child(explosion)
	if size > 1:
		_split(normal.rotated(PI / 4))
		# _split(normal)
		_split(normal.rotated(-PI / 4))


func destroy():
	queue_free()
	emit_signal("asteroid_destroyed", size)
	on_destroyed_clb.call_func(size, position)


func _split(force: Vector2):
	var asteroid = Asteroid.instance()
	asteroid.on_destroyed_clb = on_destroyed_clb
	asteroid.start(size - 1, position + force.normalized() * 2 * asteroid.get_radius(), force)
	get_parent().add_child(asteroid)


func start(sz: int, pos: Vector2, dir: Vector2):
	if -1 == sz:
		sz = max_size
	size = sz
	position = pos
	linear_velocity = dir * split_and_speed[sz]


func get_radius():
	return $CollisionShape2D.shape.radius * _get_scale()


func _fix_scale():
	$AnimatedSprite.scale = base_scale * _get_scale()
	$CollisionShape2D.scale = base_scale * _get_scale()


func _integrate_forces(state: Physics2DDirectBodyState):
	state.transform.origin = Utils.wrap_physics_body(position)



func _on_Asteroid_body_entered(body: Node):
	if body.is_in_group("asteroids"):
		# Skip collision with other asteroids
		return

	if body.has_method('hit'):
		body.hit(size, linear_velocity.normalized())
