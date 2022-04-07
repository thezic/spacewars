extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var settings_file := "user://settings.save"

var fullscreen: bool
var music_volume_db: float
var sfx_volume_db: float
var classic_controls: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()


func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)

		fullscreen = f.get_var()
		music_volume_db = f.get_var()
		sfx_volume_db = f.get_var()

		var loaded_classic_controls = f.get_var()
		classic_controls = loaded_classic_controls if loaded_classic_controls != null else true

		f.close()
		_update_settings()


func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)

	f.store_var(fullscreen)
	f.store_var(music_volume_db)
	f.store_var(sfx_volume_db)
	f.store_var(classic_controls)

	f.close()
	_update_settings()


func _update_settings():
	OS.window_fullscreen = fullscreen

	var music_bus = AudioServer.get_bus_index("MusicMaster")
	var sfx_bus = AudioServer.get_bus_index("SfxMaster")
	AudioServer.set_bus_volume_db(music_bus, music_volume_db)
	AudioServer.set_bus_volume_db(sfx_bus, sfx_volume_db)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
