extends Node

const SETTINGS_FILE = "user://settings.cfg"

var current_res_index: int = 1
var is_fullscreen: bool = false
var current_volume: float = 5.0
var is_muted: bool = false

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var config = ConfigFile.new()
	
	if config.load(SETTINGS_FILE) == OK:
		current_res_index = config.get_value("video", "resolution_index", 1)
		is_fullscreen = config.get_value("video", "fullscreen", false)
		current_volume = config.get_value("audio", "volume", 5.0)
		is_muted = config.get_value("audio", "muted", false)
	apply_video_settings(current_res_index, is_fullscreen)
	apply_audio_settings(current_volume, is_muted)

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("video", "resolution_index", current_res_index)
	config.set_value("video", "fullscreen", is_fullscreen)
	config.set_value("audio", "volume", current_volume)
	config.set_value("audio", "muted", is_muted)
	config.save(SETTINGS_FILE)

func apply_video_settings(index: int, fullscreen: bool) -> void:
	var window = get_window()
	if window.is_embedded():
		return
		
	var new_size: Vector2i
	match index:
		0: new_size = Vector2i(640, 360)
		1: new_size = Vector2i(1280, 720)
	window.size = new_size
	if fullscreen:
		window.mode = Window.MODE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED
	call_deferred("_center_window")

func _center_window() -> void:
	var window = get_window()
	if not window.is_embedded() and window.mode == Window.MODE_WINDOWED:
		window.move_to_center()

func apply_audio_settings(vol: float, muted: bool) -> void:
	AudioServer.set_bus_volume_db(0, vol / 5.0) 
	AudioServer.set_bus_mute(0, muted)
