extends CharacterBody2D

class_name PlayerController

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
@export var DISGRACE_ANIMATION: AnimatedSprite2D

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
	PAUSE = "ui_cancel",
	USE = "ui_accept"
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
var low_ceiling : bool = false
var was_on_floor : bool = true
var has_disgrace: bool = false
var can_use_disgrace: bool = false
var equiped_disgrace: Disgrace
#endregion

var state : String = "normal"
var current_state : String = "normal"

#region state var
var state_rules: Dictionary = {
	"normal": {
		"can_move": true,
		"can_jump": true,
		"can_use_item": true,
		"can_be_pushed": true,
		"animation": "idle"
	},
	"on_air": {
		"can_move": true,
		"can_jump": false,
		"can_use_item": true,
		"can_be_pushed": true,
		"animation": "jump"
	},
	"trapped": {
		"can_move": false,
		"can_jump": false,
		"can_use_item": false,
		"can_be_pushed": true,
		"animation": "disgrace"
	},
	"knockback": {
		"can_move": false, 
		"can_jump": false,
		"can_use_item": false,
		"can_be_pushed": false, 
		"animation": "hurt"
	},
	"using_disgrace": {
		"can_move": false, 
		"can_jump": false,
		"can_use_item": false,
		"can_be_pushed": true,
		"animation": "disgrace"
	}
}
#endregion

#region Main Control Flow

func _ready():
	#initialize_animations()
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()
	_apply_character()
	check_controls()
	change_state("normal")
	
func _process(_delta: float) -> void:
	if pausing_enabled:
		handle_pausing()
	handle_input()

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
	else:
		if current_state == "on_air":
			change_state("normal")
	if !immobile:
		handle_jumping()
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
	if !InputMap.has_action(controls.USE):
		push_error("No control mapped for use disgrace. Please add an input map control.")
	#if !InputMap.has_action(controls.SPRINT):
		#push_error("No control mapped for sprint. Please add an input map control. Disabling sprinting.")
		#sprint_enabled = false
#endregion

func change_state(new_state: String) -> void:
	if not state_rules.has(new_state):
		push_error("Attempted to use a state that does not exist: ", new_state)
		return
		
	current_state = new_state
	var rules = state_rules[current_state]
	
	immobile = !rules["can_move"]
	
	# play_movement_animation(rules["animation"])

func handle_jumping() -> void:
	var rules = state_rules[current_state]
	if jumping_enabled and rules["can_jump"]:
		if Input.is_action_pressed(controls.get("DOWN")) and Input.is_action_just_pressed(controls.get("JUMP")) and is_on_floor():
			position.y += 2.0 
			change_state("on_air")
			return
		if Input.is_action_just_pressed(controls.get("JUMP")) and is_on_floor():
			velocity.y = jump_velocity
			change_state("on_air")
			play_movement_animation("jump") # todo: colocar no change state?

func handle_movement() -> void:
	if Input.is_action_pressed(controls.get("LEFT")):
		WALK_ANIMATION.flip_h = true
		velocity.x = -base_speed
		play_movement_animation("walk")
			
	elif Input.is_action_pressed(controls.get("RIGHT")):
		WALK_ANIMATION.flip_h = false
		velocity.x = base_speed
		play_movement_animation("walk")
			
	else:
		velocity.x = 0
		play_movement_animation("idle")
	
func play_movement_animation(animation: String) -> void:
	if is_on_floor():
		if animation == "walk":
			WALK_ANIMATION.play("walk", 1)
		if animation == "idle":
			IDLE_ANIMATION.play("idle", 1)
	else:
		if JUMP_ANIMATION:
			JUMP_ANIMATION.play("jump", 1.5)
		

func handle_pausing() -> void:
	pass
	
func handle_input() -> void:
	var rules = state_rules[current_state]
	if current_state == "trapped" or current_state == "knockback":
		return
	if Input.is_action_just_pressed(controls.get("USE")):
		if !rules["can_use_item"]:
			return
		if has_disgrace:
			change_state("using_disgrace")
			handle_disgrace_animation()
			await get_tree().create_timer(equiped_disgrace.activation_time ).timeout
			equiped_disgrace.use()
			
func handle_disgrace_animation() -> void:
	var animation_name: String = equiped_disgrace.animation_name
	print("nome da animação: ", animation_name)
	if DISGRACE_ANIMATION.sprite_frames.has_animation(animation_name):
		change_state("using_disgrace")
		velocity.x = 0
		DISGRACE_ANIMATION.play(animation_name, 1.5)
		await DISGRACE_ANIMATION.animation_finished
		change_state("normal")

func equip(disgrace: Disgrace) -> void:
	disgrace.reparent.call_deferred(self, false)
	disgrace.set_deferred("position", $DisgraceAvailablePosition.position)
	equiped_disgrace = disgrace
	has_disgrace = true
	
func unequip() -> void:
	has_disgrace = false
	equiped_disgrace.reparent.call_deferred(self.get_parent(), false)
	
func handle_disgrace_event(disgrace: Disgrace):
	if DISGRACE_ANIMATION.sprite_frames.has_animation(disgrace.animation_name):
		change_state("trapped")
		velocity.x = 0
		DISGRACE_ANIMATION.play(disgrace.animation_name)
		await get_tree().create_timer(disgrace.activation_time ).timeout
		change_state("normal")
		
func knockback(posicao_x_do_atacante: float) -> void:
	var rules = state_rules[current_state]
	if !rules["can_be_pushed"]:
		return
	change_state("knockback")
	var direcao = 1
	if posicao_x_do_atacante > global_position.x:
		direcao = -1 
		
	velocity.x = direcao * 400.0
	velocity.y = jump_velocity * 0.8
	
	# DISGRACE_ANIMATION.play("hurt")
	
	await get_tree().create_timer(0.5).timeout
	change_state("normal")
