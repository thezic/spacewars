extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var level := 1

onready var game_over_ui := $GUI/GameOver
onready var start_timer := $LevelStartTimer
onready var world := $World

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	game_over_ui.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_LevelStart():
	print("On level start " + str(level))
	world.start(level)


func _on_level_clear():
	print("Start level " + str(level))
	level += 1
	start_timer.start()


func _on_Player_player_gameover():
	game_over_ui.visible = true
	game_over_ui.start()


func reset():
	game_over_ui.visible = false
	level = 1
	$World.reset()
	start_timer.start()
