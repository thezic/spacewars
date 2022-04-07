extends Node

signal quit_game
signal start_level(nr)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var level := 1

onready var game_over_ui := $GUI/GameOver
onready var start_timer := $LevelStartTimer
onready var world := $World
onready var gui := $GUI
onready var ufo_manager := $UfoManager
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Score.reset()
	gui.update_score(Score.score)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_LevelStart():
	print("On level start " + str(level))
	emit_signal("start_level", level)

	world.start(level)


func _on_level_clear():
	print("Start level " + str(level))
	level += 1
	start_timer.start()


func _on_Player_player_gameover():
	Score.lock()
	game_over_ui.visible = true
	game_over_ui.start()


func reset():
	game_over_ui.visible = false
	level = 1
	Score.reset()
	world.reset()
	ufo_manager.reset()
	start_timer.start()


func _on_GameOver_quit_game():
	emit_signal("quit_game")
