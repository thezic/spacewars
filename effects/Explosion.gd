extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity := Vector2()

onready var boom := $BoomAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	$Particles2D.emitting = true
	boom.play()

func start(pos: Vector2, vel: Vector2):
	position = pos
	velocity = vel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta

	if not $Particles2D.is_emitting():
		queue_free()

