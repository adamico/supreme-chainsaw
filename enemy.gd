extends CharacterBody2D

# Simple enemy AI for BattleRoom
# Follows the player when within detection range

class_name Enemy

var speed = 50.0
var player_ref = null
var detection_range = 150.0

func _ready():
	# Find player reference
	var room = get_parent()
	if room and room.has_method("get_spawned_features"):
		player_ref = room.player

func _physics_process(_delta):
	if not player_ref:
		return
	
	var distance_to_player = global_position.distance_to(player_ref.global_position)
	
	# Simple follow behavior when player is in range
	if distance_to_player < detection_range and distance_to_player > 30:
		var direction = (player_ref.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

# Public method to set player reference manually
func set_player_reference(player: CharacterBody2D):
	player_ref = player
