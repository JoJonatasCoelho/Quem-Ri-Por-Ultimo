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
		"palettes" = [
			preload("res://assets/palettes/magic/default.png"),
			preload("res://assets/palettes/magic/clown.png"),
			preload("res://assets/palettes/magic/candy_hat.png"),
			preload("res://assets/palettes/magic/holy.png"),
			preload("res://assets/palettes/magic/napolitano.png"),
			preload("res://assets/palettes/magic/old_school.png"),
			preload("res://assets/palettes/magic/overdrive.png"),
			preload("res://assets/palettes/magic/patria_amada.png"),
			preload("res://assets/palettes/magic/silver.png"),
			preload("res://assets/palettes/magic/softworks.png"),
			preload("res://assets/palettes/magic/sunset.png"),
			preload("res://assets/palettes/magic/system_schock.png"),
			preload("res://assets/palettes/magic/zero_um.png")
		]
	},
	{
		"name" = "Clown",
		"portrait" = "res://assets/icons/characters/palhaco_avatar.png",
		"sprite" = preload("res://assets/animations/clown.tres"),
		"palettes" = [
			preload("res://assets/palettes/clown/default.png"),
			preload("res://assets/palettes/clown/magician.png"),
			preload("res://assets/palettes/clown/cotton_candy.png"),
			preload("res://assets/palettes/clown/drifter.png"),
			preload("res://assets/palettes/clown/real_funny.png"),
			preload("res://assets/palettes/clown/old_school.png"),
			preload("res://assets/palettes/clown/gender_reveal.png"),
			preload("res://assets/palettes/clown/brasil.png"),
			preload("res://assets/palettes/clown/golden.png"),
			preload("res://assets/palettes/clown/softworks.png"),
			preload("res://assets/palettes/clown/midnight.png"),
			preload("res://assets/palettes/clown/smooth_clown.png"),
			preload("res://assets/palettes/clown/savana.png")
		]
	}
]
