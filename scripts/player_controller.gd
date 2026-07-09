extends CharacterBody2D

#region Character Export Group

@export_category("Character")
@export var base_speed : float = 300.0
@export var crouch_speed : float = 1.0

#@export var acceleration : float = 10.0
@export var jump_velocity : float = -450.0
@export var immobile : bool = false

@export var player_num: int = -1
#endregion

#region Nodes Export Group

@export_group("Nodes")
@export var COLLISION : CollisionShape2D
@export var IDLE_ANIMATION: AnimatedSprite2D
@export var WALK_ANIMATION: AnimatedSprite2D
@export var JUMP_ANIMATION: AnimatedSprite2D

#endregion

#region Controls Export Group
@export_group("Controls")
@export var controls : Dictionary = {
	LEFT = "ui_left",
	RIGHT = "ui_right",
	UP = "ui_up",
	DOWN	 = "ui_down",
	JUMP = "ui_accept",
	CROUCH = "crouch",
	PAUSE = "ui_cancel"
	}
#endregion

#region Feature Settings Export Group
@export_group("Feature Settings")
@export var jumping_enabled : bool = true
@export var in_air_momentum : bool = true
#@export var sprint_enabled : bool = true
#@export_enum("Hold to Sprint", "Toggle Sprint") var sprint_mode : int = 0
#@export var crouch_enabled : bool = true
#@export_enum("Hold to Crouch", "Toggle Crouch") var crouch_mode : int = 0
@export var continuous_jumping : bool = true
@export var jump_animation : bool = true
@export var pausing_enabled : bool = true
@export var gravity_enabled : bool = true
@export var dynamic_gravity : bool = false

#endregion

#region Member Variable Initialization

var speed : float = base_speed
var current_speed : float = 0.0
var state : String = "normal"
var low_ceiling : bool = false
var was_on_floor : bool = true
#endregion

#region Main Control Flow

func _ready():
	#initialize_animations()
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()
	_apply_character()
	check_controls()
	enter_normal_state()
	
func _process(_delta: float) -> void:
	if pausing_enabled:
		handle_pausing()

func _apply_character() -> void:
	if self.player_num == 1:
		$AnimatedSprite2D.sprite_frames = GlobalVals.characters[GlobalVals.p1_character].sprite
		$AnimatedSprite2D.material.set_shader_parameter("original_palette", GlobalVals.characters[GlobalVals.p1_character].palettes[0])
		$AnimatedSprite2D.material.set_shader_parameter("new_palette", GlobalVals.characters[GlobalVals.p1_character].palettes[GlobalVals.p1_palette])
		$AnimatedSprite2D.play("idle")
		print("Applying character for player ", player_num)
	if self.player_num == 2:
		$AnimatedSprite2D.sprite_frames = GlobalVals.characters[GlobalVals.p2_character].sprite
		$AnimatedSprite2D.material.set_shader_parameter("original_palette", GlobalVals.characters[GlobalVals.p2_character].palettes[0])
		$AnimatedSprite2D.material.set_shader_parameter("new_palette", GlobalVals.characters[GlobalVals.p2_character].palettes[GlobalVals.p2_palette])
		$AnimatedSprite2D.play("idle")
		print("Applying character for player ", player_num)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	handle_jumping()
	if !immobile:
		handle_movement()
	move_and_slide()

func check_controls() -> void:
	if !InputMap.has_action(controls.JUMP):
		push_error("No control mapped for jumping. Please add an input map control. Disabling jump.")
		jumping_enabled = false
	if !InputMap.has_action(controls.LEFT):
		push_error("No control mapped for move left. Please add an input map control. Disabling movement.")
		immobile = true
	if !InputMap.has_action(controls.RIGHT):
		push_error("No control mapped for move right. Please add an input map control. Disabling movement.")
		immobile = true
	if !InputMap.has_action(controls.UP):
		push_error("No control mapped for move forward. Please add an input map control. Disabling movement.")
		immobile = true
	if !InputMap.has_action(controls.DOWN):
		push_error("No control mapped for move backward. Please add an input map control. Disabling movement.")
		immobile = true
	if !InputMap.has_action(controls.PAUSE):
		push_error("No control mapped for pause. Please add an input map control. Disabling pausing.")
		pausing_enabled = false
	#if !InputMap.has_action(controls.CROUCH):
		#push_error("No control mapped for crouch. Please add an input map control. Disabling crouching.")
		#crouch_enabled = false
	#if !InputMap.has_action(controls.SPRINT):
		#push_error("No control mapped for sprint. Please add an input map control. Disabling sprinting.")
		#sprint_enabled = false

func enter_normal_state() -> void:
	#var prev_state = state # anti preempção
	state = "normal"
	speed = base_speed

#func handle_state(moving: bool) -> void:
	#pass

func handle_jumping() -> void:
	if jumping_enabled:
		if Input.is_action_just_pressed(controls.get("JUMP")) and is_on_floor():
			velocity.y = jump_velocity

func handle_movement() -> void:
	if Input.is_action_pressed(controls.get("LEFT")):
		WALK_ANIMATION.flip_h = true
		velocity.x = -base_speed
		if WALK_ANIMATION:
			WALK_ANIMATION.play("walk", 2)
			
	elif Input.is_action_pressed(controls.get("RIGHT")):
		WALK_ANIMATION.flip_h = false
		velocity.x = base_speed
		if WALK_ANIMATION:
			WALK_ANIMATION.play("walk", 2)
			
	else:
		velocity.x = 0
		if IDLE_ANIMATION:
			IDLE_ANIMATION.play("idle", 2)
	
func play_movement_animation() -> void:
	if WALK_ANIMATION.animation == "walk":
		pass
	else:
		WALK_ANIMATION.play("walk", 2)

func handle_pausing() -> void:
	pass
