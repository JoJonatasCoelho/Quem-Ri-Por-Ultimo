extends Node2D

@onready var player1_sprite: AnimatedSprite2D = $CanvasLayer/CharacterSelection/P1CharacterPanel/CharacterSprite
@onready var player2_sprite: AnimatedSprite2D = $CanvasLayer/CharacterSelection/P2CharacterPanel/CharacterSprite

var palettes_mag = [
	preload("res://assets/palettes/magic/paleta_magico.png"),
	preload("res://assets/palettes/magic/paleta_magico_blue.png"),
	preload("res://assets/palettes/magic/paleta_magico_red.png"),
	preload("res://assets/palettes/magic/paleta_magico_reverse.png"),
	preload("res://assets/palettes/magic/paleta_magico_orange.png")
]

var palettes_clown = [
	preload("res://assets/palettes/clown/clown_default.png"),
	preload("res://assets/palettes/clown/clown_green.png"),
	preload("res://assets/palettes/clown/clown_reverse.png")
]

var current_palette_p1 := 0
var current_palette_p2 := 0

func _ready():
	apply_palette(player1_sprite)
	apply_palette(player2_sprite)

func apply_palette(player: AnimatedSprite2D):
	player.material.set_shader_parameter("new_palette", palettes_clown[current_palette_p1])

func _on_left_pressed(player: int) -> void:
	if (player == 1):
		current_palette_p1 -= 1
		if current_palette_p1 < 0:
			current_palette_p1 = palettes_clown.size() - 1
		apply_palette(player1_sprite)
	elif (player == 2):
		current_palette_p2 -= 1
		if current_palette_p2 < 0:
			current_palette_p2 = palettes_clown.size() - 1
		apply_palette(player2_sprite)


func _on_right_pressed(player: int) -> void:
	if (player == 1):
		current_palette_p1 += 1
		if current_palette_p1 >= palettes_clown.size():
			current_palette_p1 = 0
		apply_palette(player1_sprite)
	elif (player == 2):
		current_palette_p2 += 1
		if current_palette_p2 >= palettes_clown.size():
			current_palette_p2 = 0
		apply_palette(player2_sprite)


func _on_left_p1_button_down() -> void:
	_on_left_pressed(1)
func _on_right_p1_button_down() -> void:
	_on_right_pressed(1)
func _on_left_p2_button_down() -> void:
	_on_left_pressed(2)
func _on_right_p2_button_down() -> void:
	_on_right_pressed(2)
