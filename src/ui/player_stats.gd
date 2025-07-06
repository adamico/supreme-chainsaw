class_name PlayerStats extends Control

@onready var experience_value: RichTextLabel = %ExperienceValue
@onready var health_value: RichTextLabel = %HealthValue


func _ready() -> void:
	# Connect signals to update stats when player health or experience changes
	EventBus.player_health_changed.connect(update_health)
	EventBus.player_experience_changed.connect(update_experience)


func update_health(health: int) -> void:
	health_value.bbcode_text = "[color=white]HP: [color=red]" + str(health)


func update_experience(experience: int) -> void:
	experience_value.bbcode_text = "[color=white]XP: [color=green]" + str(experience)