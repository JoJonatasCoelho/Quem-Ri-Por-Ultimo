extends Node2D

@onready var player_sprite: AnimatedSprite2D = $CanvasLayer/Control/P1CharacterPanel/CharacterSprite

var palettes = [
	preload("res://assets/palettes/paleta_magico.png"),
	preload("res://assets/palettes/paleta_magico_blue.png"),
	preload("res://assets/palettes/paleta_magico_red.png"),
	preload("res://assets/palettes/paleta_magico_reverse.png"),
	preload("res://assets/palettes/paleta_magico_orange.png")
]

var current_palette := 0

func _ready():
	apply_palette()

func apply_palette():
	player_sprite.material.set_shader_parameter("new_palette", palettes[current_palette])

func _on_left_pressed() -> void:
	current_palette -= 1
	if current_palette < 0:
		current_palette = palettes.size() - 1
	apply_palette()


func _on_right_pressed() -> void:
	current_palette += 1
	if current_palette >= palettes.size():
		current_palette = 0
	apply_palette()
