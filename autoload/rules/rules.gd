extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Array, Color) var LEVEL_COLORS = [
	Color8(0, 22, 64),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_background_color(level: int):
	return LEVEL_COLORS[(level - 1) % LEVEL_COLORS.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
