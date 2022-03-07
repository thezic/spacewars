extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum MENU {
	NONE,
	TITLE,
	MAIN,
	SETTINGS,
}

var menus = {
	MENU.TITLE: preload("res://ui/menu/TitleMenu.tscn").instance(),
	MENU.MAIN: preload("res://ui/menu/MainMenu.tscn").instance(),
	MENU.SETTINGS: preload("res://ui/menu/SettingsMenu.tscn").instance(),
}

var container: Node
var current_menu: Node
var menu_history = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_menu(menulevel):
	call_deferred("_deferred_load_menu", menulevel)


func _deferred_load_menu(menulevel):
	if not container:
		container = Node.new()
		container.set_name("Menu")
		get_tree().current_scene.add_child(container)

	for item in container.get_children():
		container.remove_child(item)

	if current_menu:
		menu_history.push_back(current_menu)
	current_menu = menus[menulevel]

	container.add_child(current_menu)

	if current_menu.has_method("_load_menu"):
		current_menu._load_menu()


func close_menu():
	for item in container.get_children():
		container.remove_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass