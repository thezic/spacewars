extends KinematicBody2D

export var lifespan := 0.5
export var speed := 800.0
export var damage := 10

var life := 10.0
var velocity := Vector2()
var hit_type = Constants.HitTypes.plasma_player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	life = lifespan
	#start(Vector2(100, 100), 0)


func start(pos: Vector2, dir: float, ht = Constants.HitTypes.plasma_player):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)
	hit_type = ht


func _process(delta: float):
	life -= delta
	if life <= 0:
		queue_free()


func _physics_process(delta):
	var collision := move_and_collide(velocity * delta, false)
	position = Utils.wrap_physics_body(position)
	if collision:
		if collision.collider.has_method('hit'):
			collision.collider.hit(damage, velocity.normalized(), hit_type)

		# print("Collided with " + collision.collider.name)
		# print("normal " + str(collision.normal))
		# collision.collider.apply_impulse(collision.position - collision.collider.position, -collision.normal * 200)
		queue_free()


