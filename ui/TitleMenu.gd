extends Control

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_StartGameButton_pressed():
	emit_signal("start_game")
