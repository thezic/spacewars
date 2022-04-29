extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Color) var color: Color
export(float) var size_scale := 0

var velocity := Vector2()

onready var boom := $BoomAudio
onready var particles := $Particles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if color:
		particles.color = color

	particles.scale_amount = size_scale


	particles.emitting = true
	boom.play()

func start(pos: Vector2, vel: Vector2):
	position = pos
	velocity = vel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta

	if not particles.is_emitting():
		queue_free()

