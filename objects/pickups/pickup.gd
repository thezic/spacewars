extends RigidBody2D

var pickup_info: PickupInfo = null

var speed = 50.0

onready var sprite := $Sprite
onready var pickup_area := $Area

func _ready():
	pass

func start(pos: Vector2, dir: Vector2, pi: PickupInfo):
	position = pos
	linear_velocity = dir.normalized() * speed
	pickup_info = pi

	print(pi)
	print(sprite)

	sprite.texture = pi.texture
	sprite.hframes = pi.hframes
	sprite.vframes = pi.vframes
	sprite.frame = pi.frame


func _physics_process(_delta):
	for body in pickup_area.get_overlapping_bodies():
		_try_give(body)


func _try_give(body: Node):
	if not pickup_info or not body.has_method("give_pickup"):
		return

	var received: bool = body.give_pickup(pickup_info)
	if received:
		queue_free()


func _on_Timer_timeout():
	queue_free()
