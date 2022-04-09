extends Node


var target_color: Color
var color: Color


func _ready():
	color = GameRules.get_background_color(1)
	target_color = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if color != target_color:
		color = color.linear_interpolate(target_color, delta)
		VisualServer.set_default_clear_color(color)


func _on_Game_prepare_level(level: int):
	target_color = GameRules.get_background_color(level)
