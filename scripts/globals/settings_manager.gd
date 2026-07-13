extends Node

const SETTINGS_FILE = "user://settings.cfg"

var current_res_index: int = 1
var is_fullscreen: bool = false
var is_muted: bool = false

var master_volume: float = 0.5
var music_volume: float = 0.5
var sfx_volume: float = 0.5
var keybind_actions: Dictionary = {
	"p1_left": "P1 Left",
	"p1_right": "P1 Right",
	#"p1_up": "P1 Up",
	"p1_jump": "P1 Jump",
	"p1_down": "P1 Down",
	"p1_interact": "P1 Interact",
	"p1_cancel": "P1 Cancel",
	
	"p2_left": "P2 Left",
	"p2_right": "P2 Right",
	#"p2_up": "P2 Up",
	"p2_jump": "P2 Jump",
	
	"p2_down": "P2 Down",
	"p2_interact": "P2 Interact",
	"p2_cancel": "P2 Cancel"
}

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var config = ConfigFile.new()
	
	if config.load(SETTINGS_FILE) == OK:
		current_res_index = config.get_value("video", "resolution_index", 1)
		is_fullscreen = config.get_value("video", "fullscreen", false)
		is_muted = config.get_value("audio", "muted", false)
		
		master_volume = config.get_value("audio", "master_volume", 1.0)
		music_volume = config.get_value("audio", "music_volume", 1.0)
		sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
		
		for action in keybind_actions:
			var saved_event = config.get_value("controls", action, null)
			if saved_event != null:
				InputMap.action_erase_events(action) # Limpa a tecla padrão
				InputMap.action_add_event(action, saved_event)
	apply_video_settings(current_res_index, is_fullscreen)
	apply_audio_settings() 

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("video", "resolution_index", current_res_index)
	config.set_value("video", "fullscreen", is_fullscreen)
	config.set_value("audio", "muted", is_muted)
	
	# Salvando os 3 volumes separados
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	
	for action in keybind_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			config.set_value("controls", action, events[0])
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

func apply_audio_settings() -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("Sfx")
	
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume))
	
	AudioServer.set_bus_mute(master_bus, is_muted or master_volume <= 0.001)
	AudioServer.set_bus_mute(music_bus, music_volume <= 0.001)
	AudioServer.set_bus_mute(sfx_bus, sfx_volume <= 0.001)
