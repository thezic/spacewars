extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var fullscreen_checkbox :=  $"MarginContainer/VBoxContainer/HBoxContainer/FullscreenCheckbox"
onready var music_slider := $"MarginContainer/VBoxContainer/HBoxContainer2/MusicVolume"
onready var sfx_slider := $"MarginContainer/VBoxContainer/HBoxContainer3/SoundVolume"

var music_master_bus: int
var sfx_master_bus: int

# Called when the node enters the scene tree for the first time.
func _ready():
	music_master_bus = AudioServer.get_bus_index("MusicMaster")
	sfx_master_bus = AudioServer.get_bus_index("SfxMaster")


func _load_menu():
	fullscreen_checkbox.pressed = OS.window_fullscreen
	music_slider.value = db2linear(AudioServer.get_bus_volume_db(music_master_bus))
	sfx_slider.value = db2linear(AudioServer.get_bus_volume_db(sfx_master_bus))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	Menu.load_menu(Menu.MENU.MAIN);


func _on_SaveButton_pressed():
	Settings.fullscreen = fullscreen_checkbox.pressed
	Settings.music_volume_db = AudioServer.get_bus_volume_db(music_master_bus)
	Settings.sfx_volume_db = AudioServer.get_bus_volume_db(sfx_master_bus)
	Settings.save_settings()
	Menu.load_menu(Menu.MENU.MAIN);


func _on_MusicVolume_value_changed(value:float):
	AudioServer.set_bus_volume_db(music_master_bus, linear2db(value))


func _on_SoundVolume_value_changed(value:float):
	AudioServer.set_bus_volume_db(sfx_master_bus, linear2db(value))
