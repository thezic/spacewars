extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var label := $Node2D/Label
onready var animation := $AnimationPlayer


func _ready():
	pass


func start(text, pos: Vector2):
	label.text = text
	position = pos
	animation.play("score")


func done():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
