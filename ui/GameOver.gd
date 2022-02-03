extends Control

signal restart_game


# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimationPlayer.play("game over")
	pass

func start():
	$AnimationPlayer.play("game over")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TryAgain_pressed():
	pass # Replace with function body.
	emit_signal("restart_game")


func _on_Back_pressed():
	pass # Replace with function body.
