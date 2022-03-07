extends Control

signal start_game

onready var start_game_button = $"VBoxContainer/StartGame"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _load_menu():
	start_game_button.grab_focus()


func _on_Quit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_StartGame_pressed():
	emit_signal("start_game")


func _on_Settings_pressed():
	Menu.load_menu(Menu.MENU.SETTINGS)
