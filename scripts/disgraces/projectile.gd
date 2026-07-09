extends Disgrace

@export var projectile_speed: float = 10.0

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
	add_child(RayCast2D.new(), true)
	var ray_cast: RayCast2D = get_node("RayCast2D")
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		#handle_contact(collider)
	self.queue_free()
