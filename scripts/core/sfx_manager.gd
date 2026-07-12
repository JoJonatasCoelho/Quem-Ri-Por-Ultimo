extends Node

@export var sfx_dictionary: Dictionary = {
	"change_skin" = "res://assets/audio/sfx/change_skin.wav",
	"p1_select_skin" = "res://assets/audio/sfx/p1_select_skin.wav",
	"p2_select_skin" = "res://assets/audio/sfx/p2_select_skin.wav",
	"select_character" = "res://assets/audio/sfx/select_character.wav"
}

@export_group("Random Laugh Settings")
@export var min_laugh_interval: float = 5.0  
@export var max_laugh_interval: float = 15.0 
@onready var laugh_timer: Timer = $RandomLaughTimer

func _ready() -> void:
	laugh_timer.timeout.connect(_on_laugh_timer_timeout)
	_start_random_timer()

func _start_random_timer() -> void:
	var next_time = randf_range(min_laugh_interval, max_laugh_interval)
	laugh_timer.start(next_time)

func _on_laugh_timer_timeout() -> void:
	$RandomLaughs.play()
	_start_random_timer()
	
func play_sound(sound_name: String) -> void:
	if not sfx_dictionary.has(sound_name):
		push_error("SfxManager tentou tocar um som que não existe: ", sound_name)
		return
		
	var player = AudioStreamPlayer.new()
	player.stream = load(sfx_dictionary[sound_name])
	player.bus = "Sfx"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
