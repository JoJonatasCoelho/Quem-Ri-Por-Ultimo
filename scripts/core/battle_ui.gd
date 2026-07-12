extends Control
class_name BattleUi

@onready var p1_laugh_progress: ProgressBar = $Player1InfoBox/ProgressBar
@onready var p2_laugh_progress: ProgressBar = $Player2InfoBox/ProgressBar

@onready var p1_portrait: TextureRect = $Player1InfoBox/AvatarFrame/Avatar
@onready var p2_portrait: TextureRect = $Player2InfoBox/AvatarFrame/Avatar

var match_ended: bool = false 

func _ready() -> void:
	p1_portrait.texture = load(GlobalVals.characters[GlobalVals.p1_character].portrait)
	p1_portrait.material.set_shader_parameter("original_palette", GlobalVals.characters[GlobalVals.p1_character].palettes[0])
	p1_portrait.material.set_shader_parameter("new_palette", GlobalVals.characters[GlobalVals.p1_character].palettes[GlobalVals.p1_palette])
	p2_portrait.texture = load(GlobalVals.characters[GlobalVals.p2_character].portrait)
	p2_portrait.material.set_shader_parameter("original_palette", GlobalVals.characters[GlobalVals.p2_character].palettes[0])
	p2_portrait.material.set_shader_parameter("new_palette", GlobalVals.characters[GlobalVals.p2_character].palettes[GlobalVals.p2_palette])

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
