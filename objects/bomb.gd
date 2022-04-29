extends RigidBody2D


# export(PackedScene) var Explosion
export var speed := 500

var hit_type = Constants.HitTypes.plasma_player
var damage := 100

onready var damage_area := $DamageArea

var Explosion = preload("res://effects/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start(pos: Vector2, dir: float, ht = Constants.HitTypes.plasma_player):
	position = pos
	rotation = dir
	linear_velocity = Vector2.RIGHT.rotated(dir) * speed
	hit_type = ht


func explode():
	var explosion = Explosion.instance()
	explosion.color = Color(1.5, 1.0, 0)
	explosion.size_scale = 5
	get_parent().add_child(explosion)
	explosion.start(position, Vector2.ZERO)

	for body in damage_area.get_overlapping_bodies():
		if body.has_method('hit'):
			body.hit(damage, (body.position - position).normalized(), hit_type)

	queue_free()


func _on_Timer_timeout():
	explode()



func _on_Bomb_body_entered(body:Node):
	print("BOOOM")
	explode()
