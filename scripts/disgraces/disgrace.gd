extends Node2D

class_name Disgrace

@export var disgrace_name: String
@export var animation_name: String
@export var activation_time: float # segundos

var spawnpoint: Marker2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func use() -> void:
	pass

func prepare_to_free() -> void:
	GlobalSignals.disgrace_free_spawnpoint.emit(spawnpoint)
