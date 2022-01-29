extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var level := 1


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_LevelStart():
	get_node("World").start(level)


func _on_level_clear():
	print("Start level " + str(level))
	level += 1
	$LevelStartTimer.start()
