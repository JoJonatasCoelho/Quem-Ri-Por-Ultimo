extends Control

@onready var resolution_btn = $MarginContainer/Panel/ScrollContainer/VBoxContainer/ResolutionOptionButton
@onready var resolution_label = $MarginContainer/Panel/ScrollContainer/VBoxContainer/Resolution
@onready var fullscreen_btn = $MarginContainer/Panel/ScrollContainer/VBoxContainer/Fullscreen
@onready var mute_btn = $MarginContainer/Panel/ScrollContainer/VBoxContainer/Mute
@onready var volume_slider = $MarginContainer/Panel/ScrollContainer/VBoxContainer/VolumeSlider
@onready var music_slider = $MarginContainer/Panel/ScrollContainer/VBoxContainer/MusicSlider 
@onready var sfx_slider = $MarginContainer/Panel/ScrollContainer/VBoxContainer/SfxSlider     

@onready var input_button_scene: PackedScene = preload("res://scenes/gui/action_Button.tscn")

var is_remapping: bool = false
var action_to_remap: String = ""
var button_to_remap: Button = null

func _ready() -> void:
	if OS.has_feature("web"):
		resolution_label.visible = false
		resolution_btn.visible = false
		fullscreen_btn.visible = false
		
	resolution_btn.select(SettingsManager.current_res_index)
	fullscreen_btn.button_pressed = SettingsManager.is_fullscreen
	mute_btn.button_pressed = SettingsManager.is_muted
	volume_slider.value = SettingsManager.master_volume
	music_slider.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume
	_create_action_list()

func _on_resolution_option_button_item_selected(index: int) -> void:
	SettingsManager.current_res_index = index
	SettingsManager.apply_video_settings(index, SettingsManager.is_fullscreen)
	SettingsManager.save_settings()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	SettingsManager.is_fullscreen = toggled_on
	SettingsManager.apply_video_settings(SettingsManager.current_res_index, toggled_on)
	SettingsManager.save_settings()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_volume_slider_value_changed(value: float) -> void:
	SettingsManager.master_volume = value
	_update_audio()

func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.music_volume = value
	_update_audio()

func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.sfx_volume = value
	_update_audio()

func _on_mute_toggled(toggled_on: bool) -> void:
	SettingsManager.is_muted = toggled_on
	_update_audio()

func _update_audio() -> void:
	SettingsManager.apply_audio_settings()
	SettingsManager.save_settings()

func _create_action_list():
	for action_key in SettingsManager.keybind_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		action_label.text = SettingsManager.keybind_actions[action_key]
		var events: Array[InputEvent] = InputMap.action_get_events(action_key)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")\
			.trim_suffix("- Physical")
		else:
			input_label.text = ""
		$MarginContainer/Panel/ScrollContainer/VBoxContainer.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action_key))

func _on_input_button_pressed(button: Button , action: String)-> void:
	_start_remapping(button, action)

func _start_remapping(button: Button, action: String) -> void:
	is_remapping = true
	action_to_remap = action
	button_to_remap = button
	button.find_child("LabelInput").text = "Press a key..."

func _input(event: InputEvent) -> void:
	if is_remapping:
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_ESCAPE:
				_cancel_remapping()
				return
			for action in SettingsManager.keybind_actions:
				if InputMap.action_has_event(action, event):
					InputMap.action_erase_event(action, event)
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(button_to_remap, event)
			
			is_remapping = false
			action_to_remap = ""
			button_to_remap = null
						
			SettingsManager.save_settings()
			get_viewport().set_input_as_handled()

func _update_action_list(button: Button, event: InputEvent) -> void:
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")\
			.trim_suffix("- Physical")

func _cancel_remapping() -> void:
	is_remapping = false
	var events: Array[InputEvent] = InputMap.action_get_events(action_to_remap)
	if events.size() > 0:
		button_to_remap.find_child("LabelInput").text = events[0].as_text().trim_suffix(" (Physical)")\
			.trim_suffix("- Physical")
	action_to_remap = ""
	button_to_remap = null
