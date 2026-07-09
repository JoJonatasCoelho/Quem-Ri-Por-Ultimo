extends Disgrace

@export var projectile_speed: float = 10.0

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func _on_collect_area_body_entered(body: Node2D) -> void:
	print(body)
