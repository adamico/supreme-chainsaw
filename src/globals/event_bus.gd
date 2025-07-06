extends Node

signal player_health_changed(new_health: int)
signal player_experience_changed(new_experience: int)
signal player_memory_shards_changed(new_memory_shards: int)

func _ready() -> void:
	player_health_changed.connect(_on_player_health_changed)
	player_experience_changed.connect(_on_player_experience_changed)
	player_memory_shards_changed.connect(_on_player_memory_shards_changed)


func _on_player_memory_shards_changed(new_memory_shards: int) -> void:
	print("Player memory shards changed to: ", new_memory_shards)


func _on_player_health_changed(new_health: int) -> void:
	print("Player health changed to: ", new_health)


func _on_player_experience_changed(new_experience: int) -> void:
	print("Player experience changed to: ", new_experience)
