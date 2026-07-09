extends Disgrace

@export var projectile_speed: float = 10.0
@export	var shot_range : float = 50.0 
@export var projectile_sprite: Sprite2D


func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func _on_collect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players") and !body.has_disgrace:
		if self.get_parent().is_in_group("players"):
			self.get_parent().unequip()
		body.equip(self)
		
func use() -> void:
	var player = get_parent()
	var ray_cast = player.get_node("RayCast2D")
	var base_position = player.get_node("DisgraceUsePosition")
	
	if player.WALK_ANIMATION.flip_h == true:
		ray_cast.target_position = Vector2(-shot_range, 0)
		ray_cast.position.x = -abs(base_position.position.x) 
	else:
		ray_cast.target_position = Vector2(shot_range, 0)
		ray_cast.position.x = abs(base_position.position.x)
	
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		handle_contact(collider)
	player.has_disgrace = false
	player.equiped_disgrace = null
	self.queue_free()

func handle_contact(collider: Node2D):
	print("sucessow?")
	if collider.is_in_group("players"):
		print("É sucessow")
