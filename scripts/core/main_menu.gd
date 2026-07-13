extends Control

@export var scenes: Dictionary = {
	"MULTIPLAYER_SELECTION" = "res://scenes/selection_screen.tscn",
	"SINGLEPLAYER_SELECTION" = "",
	"CONFIGURATION" = "res://scenes/configuration.tscn",
	"CREDITS" = "res://scenes/credits.tscn"
}

func _ready() -> void:
	MusicManager.update_music("menu_music")
	

func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file(scenes["MULTIPLAYER_SELECTION"])

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file(scenes["CREDITS"])

func _on_configuration_pressed() -> void:
	get_tree().change_scene_to_file(scenes["CONFIGURATION"])

func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	$ButtonsPanel.visible = true
	$GameTitle.visible = true
	$Softworks.visible = true
	$TutorialButton.visible = true
	$TutorialPanel.visible = false


func _on_tutorial_button_pressed() -> void:
	$ButtonsPanel.visible = false
	$GameTitle.visible = false
	$Softworks.visible = false
	$TutorialButton.visible = false
	$TutorialPanel.visible = true
