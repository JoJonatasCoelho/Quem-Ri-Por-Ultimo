extends Disgrace

@export var projectile_speed: float = 400.0 
@export var shot_range : float = 500.0 
@export var projectile_sprite: Sprite2D

var is_fired: bool = false
var direction: Vector2 = Vector2.ZERO
var distance_traveled: float = 0.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_fired:
		var movement = direction * projectile_speed * delta
		global_position += movement
		distance_traveled += movement.length()
		
		if distance_traveled >= shot_range:
			queue_free()

func _on_collect_area_body_entered(body: Node2D) -> void:
	if is_fired:
		handle_contact(body)
	else:
		if body.is_in_group("players") and !body.has_disgrace:
			if self.get_parent().is_in_group("players"):
				self.get_parent().unequip()
			body.equip(self)
		
func use() -> void:
	var player = get_parent()
	var base_position = player.get_node("DisgraceUsePosition")
	
	if player.WALK_ANIMATION.flip_h == true:
		direction = Vector2.LEFT
	else:
		direction = Vector2.RIGHT
	
	var spawn_position = base_position.global_position
	
	player.remove_child(self)
	print(activation_time)
	player.get_tree().current_scene.add_child(self)

	self.global_position = spawn_position
	projectile_sprite.visible = true
	self.is_fired = true
	
	player.has_disgrace = false
	player.equiped_disgrace = null

func handle_contact(collider: Node2D):
	print("sucessow?")
	if collider.is_in_group("players"):
		print("É sucessow")
	queue_free()
