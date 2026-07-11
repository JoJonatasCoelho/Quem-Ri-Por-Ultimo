extends Disgrace

@export var sprite: AnimatedSprite2D
@export var laugh_available: float

var current_player: PlayerController

@onready var is_active: bool = false 

func _process(delta: float) -> void:
	if is_active:
		laugh_available -= delta
	
	if laugh_available <= 0:
		laugh_available = 0
		_handle_depleted()
		self.queue_free()
		
func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body is PlayerController and body.is_in_group("players"):
		if !current_player and !body.has_disgrace:
			print("oi")
			_handle_use(body)
		elif current_player and body != current_player:
			_handle_dispute(body)
		
func _handle_dispute(atacker: PlayerController) -> void:
	if atacker.has_disgrace:
		return 
	var victm = current_player
	victm.knockback(atacker.global_position.x)
	_handle_use(atacker)

func _handle_use(body: PlayerController) -> void:
	current_player = body
	is_active = true
	sprite.play("in_use")
	current_player.handle_disgrace_event(self)
	
func _handle_depleted() -> void:
	is_active = false
	print("acabou evento")
	if current_player:
		current_player.change_state("normal") 
		current_player = null
	queue_free()
