extends Node2D

class_name Disgrace

@export var disgrace_name: String
@export var animation_name: String
@export var activation_time: float # segundos

var weight: float = 1
@export var spawngroup: String # large or small

var spawnpoint: Marker2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func use() -> void:
	pass

func prepare_to_free() -> void:
	# emitir sinal pro manager
	# libera o spawnpoint
	# manager inicia o timer de spawn
	pass
