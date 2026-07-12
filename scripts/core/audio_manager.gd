extends Node


func _ready() -> void:
	var music_player: AudioStreamPlayer = $BackgroundMusicPlayer
	
	# TODO: configurar essa desgraça
	music_player.volume_db = -20
