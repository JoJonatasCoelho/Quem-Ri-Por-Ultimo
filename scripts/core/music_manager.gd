extends AudioStreamPlayer

func update_music(music_name: String) -> void:
	self["parameters/switch_to_clip"] = music_name

func stop_music() -> void:
	stop()
