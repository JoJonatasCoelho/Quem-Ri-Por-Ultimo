extends Control

@export var scenes: Dictionary = {
	"MULTIPLAYER_SELECTION" = "res://scenes/selection_screen.tscn",
	"SINGLEPLAYER_SELECTION" = "",
	"CONFIGURATION" = "res://scenes/configuration.tscn"
}

func _ready() -> void:
	pass
	

func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file(scenes["MULTIPLAYER_SELECTION"])
	

func _on_singleplayer_pressed() -> void:
	pass # Replace with function body.


func _on_configuration_pressed() -> void:
	get_tree().change_scene_to_file(scenes["CONFIGURATION"])



func _on_sair_pressed() -> void:
	get_tree().quit()
