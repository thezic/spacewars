# class_name Utils
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screensize: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport_rect().size
	# pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func wrap_physics_body(position: Vector2) -> Vector2:
	return Vector2(
		wrapf(position.x, 0, screensize.x),
		wrapf(position.y, 0, screensize.y))