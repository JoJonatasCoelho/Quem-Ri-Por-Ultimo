extends Node2D

@export var players_positions: Array[Marker2D]

func _ready() -> void:
	initialize_players()


func _process(_delta: float) -> void:
	pass

func initialize_players() -> void:
	$Player.position = players_positions[0].position
	$Player2.position = players_positions[1].position
	$Player2/AnimatedSprite2D.flip_h = true
