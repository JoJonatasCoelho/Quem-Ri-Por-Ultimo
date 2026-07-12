extends Node2D

@onready var player1_sprite: AnimatedSprite2D = $CanvasLayer/CharacterSelection/P1CharacterPanel/CharacterSprite
@onready var player2_sprite: AnimatedSprite2D = $CanvasLayer/CharacterSelection/P2CharacterPanel/CharacterSprite

@onready var player1_panel: StyleBoxTexture = $CanvasLayer/CharacterSelection/P1CharacterPanel.get_theme_stylebox("panel")
@onready var player2_panel: StyleBoxTexture = $CanvasLayer/CharacterSelection/P2CharacterPanel.get_theme_stylebox("panel")

@onready var characters_grid: GridContainer = $CanvasLayer/CharacterSelection/CharactersGrid
@onready var characters: Array[Node] = characters_grid.get_children()

enum PlayerState {
	SELECT_CHARACTER,
	SELECT_PALETTE,
	LOCKED
}

var p1_state = PlayerState.SELECT_CHARACTER
var p2_state = PlayerState.SELECT_CHARACTER

var p1_cursor_idx: int = 0
@onready var p1_cursor = $CanvasLayer/CharacterSelection/P1Cursor
var p2_cursor_idx: int = 0
@onready var p2_cursor = $CanvasLayer/CharacterSelection/P2Cursor

@onready var p1_leftbutton = $CanvasLayer/CharacterSelection/P1CharacterPanel/LeftP1
@onready var p1_rightbutton = $CanvasLayer/CharacterSelection/P1CharacterPanel/RightP1
@onready var p2_leftbutton = $CanvasLayer/CharacterSelection/P2CharacterPanel/LeftP2
@onready var p2_rightbutton = $CanvasLayer/CharacterSelection/P2CharacterPanel/RightP2

@onready var p1_palette_title = $CanvasLayer/CharacterSelection/P1CharacterPanel/P1PaletteName
@onready var p2_palette_title = $CanvasLayer/CharacterSelection/P2CharacterPanel/P2PaletteName

@onready var p1_ready = $CanvasLayer/CharacterSelection/P1CharacterPanel/P1Ready
@onready var p2_ready = $CanvasLayer/CharacterSelection/P2CharacterPanel/P2Ready
@onready var start_text = $CanvasLayer/CharacterSelection/Start

var current_palette_p1 := 0
var current_palette_p2 := 0

func _ready():
	MusicManager.update_music("selection_music")
	p1_leftbutton.hide()
	p1_rightbutton.hide()
	p2_leftbutton.hide()
	p2_rightbutton.hide()
	p1_ready.hide()
	p2_ready.hide()
	start_text.hide()
	apply_palette(player1_sprite, GlobalVals.characters[0].palettes, current_palette_p1)
	apply_palette(player2_sprite, GlobalVals.characters[0].palettes, current_palette_p2)
	
func _process(_delta: float) -> void:
	if (p1_state == PlayerState.LOCKED) and (p2_state == PlayerState.LOCKED):
		p1_ready.hide()
		p2_ready.hide()
		start_text.show()
		if Input.is_action_just_pressed("p1_interact"):
			GlobalVals.p1_character = p1_cursor_idx
			GlobalVals.p2_character = p2_cursor_idx
			GlobalVals.p1_palette = current_palette_p1
			GlobalVals.p2_palette = current_palette_p2
			get_tree().change_scene_to_file("res://scenes/maps/circus.tscn")
	
	match p1_state:
		PlayerState.SELECT_CHARACTER:
			update_p1_cursor()
		PlayerState.SELECT_PALETTE:
			if Input.is_action_just_pressed("p1_cancel"):
				p1_leftbutton.disabled = true
				p1_leftbutton.hide()
				p1_rightbutton.disabled = true
				p1_rightbutton.hide()
				p1_state = PlayerState.SELECT_CHARACTER
				p1_cursor.texture = load("res://assets/placeholders/p1_cursor.png")
				player1_panel.texture = load("res://assets/placeholders/frame.png")
			if Input.is_action_just_pressed("p1_interact"):
				p1_leftbutton.disabled = true
				p1_leftbutton.hide()
				p1_rightbutton.disabled = true
				p1_rightbutton.hide()
				p1_state = PlayerState.LOCKED
				if !(p2_state == PlayerState.LOCKED):
					p1_ready.show()
	
	match p2_state:
		PlayerState.SELECT_CHARACTER:
			update_p2_cursor()
		PlayerState.SELECT_PALETTE:
			if Input.is_action_just_pressed("p2_cancel"):
				p2_leftbutton.disabled = true
				p2_leftbutton.hide()
				p2_rightbutton.disabled = true
				p2_rightbutton.hide()
				p2_state = PlayerState.SELECT_CHARACTER
				p2_cursor.texture = load("res://assets/placeholders/p2_cursor.png")
				player2_panel.texture = load("res://assets/placeholders/frame.png")
			if Input.is_action_just_pressed("p2_interact"):
				p2_leftbutton.disabled = true
				p2_leftbutton.hide()
				p2_rightbutton.disabled = true
				p2_rightbutton.hide()
				p2_state = PlayerState.LOCKED
				if !(p1_state == PlayerState.LOCKED):
					p2_ready.show()

func update_p1_cursor():
	if Input.is_action_just_pressed("p1_right"):
		p1_cursor_idx = (p1_cursor_idx + 1) % characters_grid.columns
	if Input.is_action_just_pressed("p1_left"):
		p1_cursor_idx = (p1_cursor_idx - 1 + characters_grid.columns) % characters_grid.columns
		
	var character: TextureRect = characters[p1_cursor_idx]
	player1_sprite.material.set_shader_parameter("original_palette", GlobalVals.characters[p1_cursor_idx].palettes[0])
	player1_sprite.material.set_shader_parameter("new_palette", GlobalVals.characters[p1_cursor_idx].palettes[0])
	p1_palette_title.texture = GlobalVals.characters[p1_cursor_idx].titles[0]
	player1_sprite.sprite_frames = GlobalVals.characters[p1_cursor_idx].sprite
	player1_sprite.play("idle")
	p1_cursor.global_position = character.global_position
	
	if Input.is_action_just_pressed("p1_interact"):
		p1_cursor.texture = load("res://assets/placeholders/p1_cursor_selected.png")
		GlobalVals.p1_character = p1_cursor_idx
		p1_state = PlayerState.SELECT_PALETTE
		p1_leftbutton.disabled = false
		p1_leftbutton.show()
		p1_rightbutton.disabled = false
		p1_rightbutton.show()
		player1_panel.texture = load("res://assets/placeholders/frame_p1_select.png")
		
	
func update_p2_cursor():
	if Input.is_action_just_pressed("p2_right"):
		p2_cursor_idx = (p2_cursor_idx + 1) % characters_grid.columns
	if Input.is_action_just_pressed("p2_left"):
		p2_cursor_idx = (p2_cursor_idx - 1 + characters_grid.columns) % characters_grid.columns
		
	var character: TextureRect = characters[p2_cursor_idx]
	player2_sprite.material.set_shader_parameter("original_palette", GlobalVals.characters[p2_cursor_idx].palettes[0])
	player2_sprite.material.set_shader_parameter("new_palette", GlobalVals.characters[p2_cursor_idx].palettes[0])
	p2_palette_title.texture = GlobalVals.characters[p2_cursor_idx].titles[0]
	player2_sprite.sprite_frames = GlobalVals.characters[p2_cursor_idx].sprite
	player2_sprite.play("idle")
	p2_cursor.global_position = character.global_position
	
	if Input.is_action_just_pressed("p2_interact"):
		p2_cursor.texture = load("res://assets/placeholders/p2_cursor_selected.png")
		GlobalVals.p2_character = p2_cursor_idx
		p2_state = PlayerState.SELECT_PALETTE
		p2_leftbutton.disabled = false
		p2_leftbutton.show()
		p2_rightbutton.disabled = false
		p2_rightbutton.show()
		player2_panel.texture = load("res://assets/placeholders/frame_p2_select.png")

func apply_palette(sprite: AnimatedSprite2D, palettes: Array, current_palette: int):
	sprite.material.set_shader_parameter("new_palette", palettes[current_palette])

func _cycle_palette_left(player: int) -> void:
	if (player == 1) and (p1_state == PlayerState.SELECT_PALETTE):
		current_palette_p1 -= 1
		if current_palette_p1 < 0:
			current_palette_p1 = GlobalVals.characters[p1_cursor_idx].palettes.size() - 1
		p1_palette_title.texture = GlobalVals.characters[p1_cursor_idx].titles[current_palette_p1]
		apply_palette(player1_sprite, GlobalVals.characters[p1_cursor_idx].palettes, current_palette_p1)
	elif (player == 2) and (p2_state == PlayerState.SELECT_PALETTE):
		current_palette_p2 -= 1
		if current_palette_p2 < 0:
			current_palette_p2 = GlobalVals.characters[p2_cursor_idx].palettes.size() - 1
		p2_palette_title.texture = GlobalVals.characters[p2_cursor_idx].titles[current_palette_p2]
		apply_palette(player2_sprite, GlobalVals.characters[p2_cursor_idx].palettes, current_palette_p2)

func _cycle_palette_right(player: int) -> void:
	if (player == 1) and (p1_state == PlayerState.SELECT_PALETTE):
		current_palette_p1 += 1
		if current_palette_p1 >= GlobalVals.characters[p1_cursor_idx].palettes.size():
			current_palette_p1 = 0
		p1_palette_title.texture = GlobalVals.characters[p1_cursor_idx].titles[current_palette_p1]
		apply_palette(player1_sprite, GlobalVals.characters[p1_cursor_idx].palettes, current_palette_p1)
	elif (player == 2) and (p2_state == PlayerState.SELECT_PALETTE):
		current_palette_p2 += 1
		if current_palette_p2 >= GlobalVals.characters[p2_cursor_idx].palettes.size():
			current_palette_p2 = 0
		p2_palette_title.texture = GlobalVals.characters[p2_cursor_idx].titles[current_palette_p2]
		apply_palette(player2_sprite, GlobalVals.characters[p2_cursor_idx].palettes, current_palette_p2)

func _on_left_p_1_pressed() -> void:
	_cycle_palette_left(1)
func _on_right_p_1_pressed() -> void:
	_cycle_palette_right(1)
func _on_left_p_2_pressed() -> void:
	_cycle_palette_left(2)
func _on_right_p_2_pressed() -> void:
	_cycle_palette_right(2)
