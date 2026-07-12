extends Control

@onready var resolution_btn = $MarginContainer/Panel/VBoxContainer/ResolutionOptionButton
@onready var resolution_label = $MarginContainer/Panel/VBoxContainer/Resolution
@onready var fullscreen_btn = $MarginContainer/Panel/VBoxContainer/Fullscreen
@onready var mute_btn = $MarginContainer/Panel/VBoxContainer/Mute
@onready var volume_slider = $MarginContainer/Panel/VBoxContainer/VolumeSlider
@onready var music_slider = $MarginContainer/Panel/VBoxContainer/MusicSlider 
@onready var sfx_slider = $MarginContainer/Panel/VBoxContainer/SfxSlider     

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
