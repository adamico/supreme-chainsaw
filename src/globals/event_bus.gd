extends Node

signal player_health_changed(new_health: int, max_health: int)
signal player_experience_changed(new_experience: int)
signal player_memory_shards_changed(new_memory_shards: int)
signal player_attack_rate_changed(new_attack_rate: float)
signal player_attack_damage_changed(new_attack_damage: int)
signal player_activated_sacrifice_shrine(player: Node2D, shrine: Node2D)
signal player_entered_sacrifice_room
signal card_offer_accepted

func _ready() -> void:
	player_health_changed.connect(_on_player_health_changed)
	player_experience_changed.connect(_on_player_experience_changed)
	player_memory_shards_changed.connect(_on_player_memory_shards_changed)
	player_attack_rate_changed.connect(_on_player_attack_rate_changed)
	player_attack_damage_changed.connect(_on_player_attack_damage_changed)
	player_activated_sacrifice_shrine.connect(_on_player_activated_sacrifice_shrine)
	player_entered_sacrifice_room.connect(_on_player_entered_sacrifice_room)
	card_offer_accepted.connect(_on_card_offer_accepted)


func _on_player_memory_shards_changed(new_memory_shards: int) -> void:
	print("Player memory shards changed to: ", new_memory_shards)


func _on_player_health_changed(new_health: int, max_health: int) -> void:
	print("Player health changed to: ", new_health, "/", max_health)


func _on_player_experience_changed(new_experience: int) -> void:
	print("Player experience changed to: ", new_experience)


func _on_player_attack_rate_changed(new_attack_rate: float) -> void:
	print("Player attack rate changed to: ", new_attack_rate)


func _on_player_attack_damage_changed(new_attack_damage: int) -> void:
	print("Player attack damage changed to: ", new_attack_damage)


func _on_player_activated_sacrifice_shrine(player: Node2D, shrine: Node2D) -> void:
	print("Player ", player.name, " activated sacrifice shrine: ", shrine.name)


func _on_player_entered_sacrifice_room() -> void:
	print("Player entered sacrifice room")
	

func _on_card_offer_accepted() -> void:
	print("Card offer accepted")