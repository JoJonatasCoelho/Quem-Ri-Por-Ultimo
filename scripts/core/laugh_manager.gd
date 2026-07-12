extends Node

@onready var p1_laughs: float = 0
@onready var p2_laughs: float = 0
@onready var p1_using_event: bool = false
@onready var p2_using_event: bool = false

@export var battle_ui: BattleUi
@export var win_context: Node

@export var player1_name_texture: CompressedTexture2D
@export var player2_name_texture: CompressedTexture2D

@onready var menu_scene: String = "res://scenes/main_menu.tscn"


func _ready() -> void:
	GlobalSignals.hit_adversary.connect(give_laugh)
	GlobalSignals.missed_adversary.connect(give_laugh)
	
	GlobalSignals.using_event_disgrace.connect(handle_event_use)
	GlobalSignals.exited_event_disgrace.connect(handle_event_exit)
	
	GlobalSignals.player_reached_max_laugh.connect(finish_match)
	
func _process(delta: float) -> void:
	print("p1 risadas: ", p1_laughs)
	print("p2 risadas: ", p2_laughs)
	if p1_using_event:
		p1_laughs += delta
		battle_ui.increase_laugh_continuous(1, delta)
	if p2_using_event:
		p2_laughs += delta
		battle_ui.increase_laugh_continuous(2, delta)
	pass

func give_laugh(player: PlayerController, laugh_value: int) -> void:
	match player.player_num:
		1:
			p1_laughs += laugh_value
			battle_ui.increase_laugh_impact(1, laugh_value)
		2:
			p2_laughs += laugh_value
			battle_ui.increase_laugh_impact(2, laugh_value)

func handle_event_use(player: PlayerController) -> void:
	match player.player_num:
		1:	
			p1_using_event = true
		2:
			p2_using_event = true

func handle_event_exit(player: PlayerController) -> void:
	match player.player_num:
		1:	
			p1_using_event = false
		2:
			p2_using_event = false

func finish_match(winner_idx: int):
	set_process(false)
	var win_panel: Panel = win_context.get_node("ShadowScreen")
	var player_label: TextureRect = win_context.get_node("PlayerWinner")
	var win_label: TextureRect = win_context.get_node("WinLabel")
	var buttons: VBoxContainer = win_context.get_node("Buttons")
	win_panel.visible = true
	match winner_idx:
		1: 
			player_label.texture = player1_name_texture
		2:
			player_label.texture = player2_name_texture
	player_label.visible = true
	win_label.visible = true
	buttons.visible = true


func _on_menu_pressed() -> void:
	SfxManager.toggle_random_laugh()
	get_tree().change_scene_to_file(menu_scene)
