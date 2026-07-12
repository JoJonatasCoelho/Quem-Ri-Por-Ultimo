extends Node2D

@export var map_spawnpoints: Array[Marker2D]
var occupied_spawnpoints: Array[Marker2D]

@export var max_disgraces: int = 1
var current_max_disgraces: int = 1 # should increase from time to time until reaches max_disgraces
var disgraces_count: int = 0

@export var disgrace_respawn_cooldown: float = 3.0 # seconds
@export var increase_curr_max_cooldown: float = 15.0 #seconds

@export var disgraces: Array[PackedScene]

@onready var increase_max_timer: Timer = $IncreaseMaxCooldown
@onready var respawn_timer: Timer = $RespawnCooldown

func _ready() -> void:
	GlobalSignals.disgrace_free_spawnpoint.connect(free_spawpoint)
	increase_max_timer.wait_time = increase_curr_max_cooldown
	respawn_timer.wait_time = disgrace_respawn_cooldown
	increase_max_timer.start()

func _process(_delta: float) -> void:
	if ((increase_max_timer.is_stopped()) and (current_max_disgraces < max_disgraces)):
		current_max_disgraces += 1
		increase_max_timer.start()
	if not (occupied_spawnpoints.size() == map_spawnpoints.size()):
		if (disgraces_count < current_max_disgraces) and (respawn_timer.is_stopped()):
			spawn()
		pass
	pass

func free_spawpoint(spawnpoint: Marker2D):
	occupied_spawnpoints.erase(spawnpoint)
	if (respawn_timer.is_stopped()):
		respawn_timer.start()
	disgraces_count -= 1

func spawn():
	if not (map_spawnpoints.is_empty() and disgraces.is_empty()):
		var item: PackedScene = disgraces.pick_random()
		var available_spawnpoints = map_spawnpoints.filter(func (entry: Marker2D):
			if occupied_spawnpoints.has(entry):
				return false
			for group in item.get_state().get_node_groups(0):
				if entry.is_in_group(group):
					return true
			return false)
		if (available_spawnpoints.is_empty()):
			return
		var spawnpoint: Marker2D = available_spawnpoints.pick_random()
		var spawned_item: Disgrace = item.instantiate()
		spawned_item.global_position = spawnpoint.global_position
		spawned_item.spawnpoint = spawnpoint
		get_parent().add_child.call_deferred(spawned_item)
		disgraces_count += 1
		occupied_spawnpoints.append(spawnpoint)
		if (respawn_timer.is_stopped()):
			respawn_timer.start()
