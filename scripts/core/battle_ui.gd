extends Control
class_name BattleUi

@onready var p1_laugh_progress: ProgressBar = $Player1InfoBox/ProgressBar
@onready var p2_laugh_progress: ProgressBar = $Player2InfoBox/ProgressBar

var match_ended: bool = false 

func _process(_delta: float) -> void:
	if match_ended:
		return
	if p1_laugh_progress.value >= 100:
		p1_laugh_progress.value = 100
		match_ended = true 
		GlobalSignals.player_reached_max_laugh.emit(1)
	elif p2_laugh_progress.value >= 100:
		p2_laugh_progress.value = 100
		match_ended = true 
		GlobalSignals.player_reached_max_laugh.emit(2)

func increase_laugh_impact(player:int, value: float) -> void:
	match player:
		1:
			var new_laugh = p1_laugh_progress.value + value
			var tween = create_tween()
			tween.tween_property(p1_laugh_progress, "value", new_laugh, 0.5)
		2:
			var new_laugh = p2_laugh_progress.value + value
			var tween = create_tween()
			tween.tween_property(p2_laugh_progress, "value", new_laugh, 0.5)

func increase_laugh_continuous(player:int, value: float) -> void:
	match player:
		1:
			p1_laugh_progress.value += value
		2:
			p2_laugh_progress.value += value
