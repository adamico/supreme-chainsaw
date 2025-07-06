# Simple enemy AI for BattleRoom
# Follows the player when within detection range
class_name Enemy extends CharacterBody2D

@export var damage:= 10.0
@export var detection_range:= 150.0
@export var speed:= 50.0
@export var experience_reward:= 10.0

var player_ref: CharacterBody2D = null
var room: Room = null

@onready var hurt_box: HurtBoxComponent = %HurtBoxComponent


func _ready() -> void:
	room = get_parent()  # Assuming the enemy is a child of the room
	if is_instance_valid(room):
		player_ref = room.player
		print("Enemy initialized - Player reference:", player_ref)

	hurt_box.died.connect(_on_died)


func _physics_process(_delta) -> void:
	if not player_ref:
		print("No player reference found, cannot follow")
		return

	var distance_to_player = global_position.distance_to(player_ref.global_position)

	# Simple follow behavior when player is in range
	if distance_to_player < detection_range and distance_to_player > 30:
		var direction = (player_ref.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO


func _on_died() -> void:
	_give_experience()
	_drop_loot()
	queue_free()  # Remove enemy from the scene


func _drop_loot() -> void:
	print("Enemy died, dropping loot")
	room.call_deferred(&"spawn_feature", Room.FeatureType.HEALTH_PACK, global_position)


func _give_experience() -> void:
	print("Enemy died, rewarding experience")
	if player_ref:
		player_ref.experience += experience_reward
		print("Player rewarded with", experience_reward, "experience")
