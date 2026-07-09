extends CharacterBody2D

#region Character Export Group

@export_category("Character")
@export var base_speed : float = 300.0
@export var crouch_speed : float = 1.0

#@export var acceleration : float = 10.0
@export var jump_velocity : float = -450.0
@export var immobile : bool = false
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
var state : String = "normal"
var low_ceiling : bool = false
var was_on_floor : bool = true
var has_disgrace: bool = false
var can_use_disgrace: bool = false
var equiped_disgrace: Disgrace
#endregion

#region Main Control Flow

func _ready():
	#initialize_animations()
	check_controls()
	enter_normal_state()
	
func _process(_delta: float) -> void:
	if pausing_enabled:
		handle_pausing()
	handle_input()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
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
			state = "on_air"
			play_movement_animation("jump")

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
			WALK_ANIMATION.play("walk", 2)
		if animation == "idle":
			IDLE_ANIMATION.play("idle", 2)
	else:
		if JUMP_ANIMATION:
			JUMP_ANIMATION.play("jump", 2)
		

func handle_pausing() -> void:
	pass
	
func handle_input() -> void:
	if Input.is_action_just_pressed(controls.get("USE")):
		if has_disgrace:
			handle_disgrace_animation()
			equiped_disgrace.use()
			
func handle_disgrace_animation() -> void:
	# Todo: melhorar a forma de lidar com ele estar imóvel?
	var animation_name: String = equiped_disgrace.animation_name
	print("nome da animação: ", animation_name)
	if DISGRACE_ANIMATION.sprite_frames.has_animation(animation_name):
		immobile = true
		DISGRACE_ANIMATION.play(animation_name, 2)
		await DISGRACE_ANIMATION.animation_finished
		immobile = false


func equip(disgrace: Disgrace) -> void:
	disgrace.reparent.call_deferred(self, false)
	disgrace.set_deferred("position", $DisgraceAvailablePosition.position)
	equiped_disgrace = disgrace
	has_disgrace = true
	
func unequip() -> void:
	has_disgrace = false
	equiped_disgrace.reparent.call_deferred(self.get_parent(), false)
