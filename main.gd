extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Game = preload("res://game/Game.tscn")

var game: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Menu.load_menu(Menu.MENU.TITLE)
	Menu.menus[Menu.MENU.MAIN].connect("start_game", self, "_on_start_game")


func _on_start_game():
	Menu.close_menu()
	game = Game.instance()
	game.connect("quit_game", self, "_on_quit_game")
	add_child(game)


func _on_quit_game():
	Menu.load_menu(Menu.MENU.TITLE)
	game.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
