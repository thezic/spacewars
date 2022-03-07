extends Control

signal restart_game
signal quit_game

onready var restart_button := $"VBoxContainer/TryAgain"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$AnimationPlayer.play("game over")

func start():
	restart_button.grab_focus()
	$AnimationPlayer.play("game over")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TryAgain_pressed():
	pass # Replace with function body.
	emit_signal("restart_game")


func _on_Back_pressed():
	emit_signal("quit_game")
	pass # Replace with function body.
