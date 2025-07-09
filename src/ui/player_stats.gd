class_name PlayerStats extends Control

@onready var experience_value: RichTextLabel = %ExperienceValue
@onready var health_value: RichTextLabel = %HealthValue
@onready var memory_shards_value: RichTextLabel = %MemoryShardsValue


func _ready() -> void:
	EventBus.player_health_changed.connect(update_health)
	EventBus.player_experience_changed.connect(update_experience)
	EventBus.player_memory_shards_changed.connect(update_memory_shards)


func update_health(health: int, max_health: int) -> void:
	health_value.bbcode_text = "[color=white]HP: [color=" + Constants.HEALTH_COLOR + "]" + str(health) + "/" + str(max_health) + "[/color]"


func update_experience(experience: int) -> void:
	experience_value.bbcode_text = "[color=white]XP: [color=" + Constants.EXPERIENCE_COLOR + "]" + str(experience) + "[/color]"


func update_memory_shards(memory_shards: int) -> void:
	memory_shards_value.bbcode_text = "[color=white]MS: [color=" + Constants.MEMORY_SHARD_COLOR + "]" + str(memory_shards) + "[/color]"