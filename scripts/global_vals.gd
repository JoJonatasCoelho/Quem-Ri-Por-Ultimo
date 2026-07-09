extends Node

@export var p1_character: int
@export var p2_character: int

@export var p1_palette: int
@export var p2_palette: int

var characters = [
	{
		"name" = "Magician",
		"portrait" = "res://assets/icons/characters/magician_avatar.png",
		"sprite" = preload("res://assets/animations/magician.tres"),
		"hframes" = 11,
		"vframes" = 1,
		"palettes" = [
			preload("res://assets/palettes/magic/paleta_magico.png"),
			preload("res://assets/palettes/magic/paleta_magico_blue.png"),
			preload("res://assets/palettes/magic/paleta_magico_orange.png"),
			preload("res://assets/palettes/magic/paleta_magico_red.png"),
			preload("res://assets/palettes/magic/paleta_magico_reverse.png")
		]
	},
	{
		"name" = "Clown",
		"portrait" = "res://assets/icons/characters/palhaco_avatar.png",
		"sprite" = preload("res://assets/animations/clown.tres"),
		"hframes" = 6,
		"vframes" = 1,
		"palettes" = [
			preload("res://assets/palettes/clown/clown_default.png"),
			preload("res://assets/palettes/clown/clown_green.png"),
			preload("res://assets/palettes/clown/clown_reverse.png")
		]
	}
]
