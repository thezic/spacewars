extends Control


onready var start_button := $"VBoxContainer/StartGameButton"


#func _enter_tree():
#	request_ready()


func _ready():
	pass


func _load_menu():
	start_button.grab_focus()


func _on_StartGameButton_pressed():
	Menu.load_menu(Menu.MENU.MAIN)
