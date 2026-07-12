extends Node

@warning_ignore("unused_signal")
signal hit_adversary(shooteer: PlayerController, laugh_value: int)

@warning_ignore("unused_signal")
signal missed_adversary(adversary: PlayerController, laugh_value: int)

@warning_ignore("unused_signal")
signal using_event_disgrace(player: PlayerController)

@warning_ignore("unused_signal")
signal exited_event_disgrace(player: PlayerController)

@warning_ignore("unused_signal")
signal player_reached_max_laugh(player_idx: int)

@warning_ignore("unused_signal")
signal disgrace_free_spawnpoint(spawnpoint: Marker2D)
