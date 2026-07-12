extends Control

@onready var resolution_btn = $MarginContainer/Panel/VBoxContainer/ResolutionOptionButton
@onready var resolution_label = $MarginContainer/Panel/VBoxContainer/Resolution
@onready var fullscreen_btn = $MarginContainer/Panel/VBoxContainer/Fullscreen
@onready var volume_slider = $MarginContainer/Panel/VBoxContainer/VolumeSlider
@onready var mute_btn = $MarginContainer/Panel/VBoxContainer/Mute

func _ready() -> void:
	if OS.has_feature("web"):
		resolution_label.visible = false
		resolution_btn.visible = false
		fullscreen_btn.visible = false
		
	resolution_btn.select(SettingsManager.current_res_index)
	fullscreen_btn.button_pressed = SettingsManager.is_fullscreen
	volume_slider.value = SettingsManager.current_volume
	mute_btn.button_pressed = SettingsManager.is_muted

func _on_resolution_option_button_item_selected(index: int) -> void:
	SettingsManager.current_res_index = index
	SettingsManager.apply_video_settings(index, SettingsManager.is_fullscreen)
	SettingsManager.save_settings()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	SettingsManager.is_fullscreen = toggled_on
	SettingsManager.apply_video_settings(SettingsManager.current_res_index, toggled_on)
	SettingsManager.save_settings()

func _on_volume_slider_value_changed(value: float) -> void:
	SettingsManager.current_volume = value
	SettingsManager.apply_audio_settings(value, SettingsManager.is_muted)
	SettingsManager.save_settings()

func _on_mute_toggled(toggled_on: bool) -> void:
	SettingsManager.is_muted = toggled_on
	SettingsManager.apply_audio_settings(SettingsManager.current_volume, toggled_on)
	SettingsManager.save_settings()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
