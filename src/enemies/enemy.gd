# Simple enemy AI for BattleRoom
# Follows the player when within detection range
class_name Enemy extends CharacterBody2D

signal died

# State enum for state machine
enum EnemyState {
	IDLE,
	MOVING,
	DASHING,
	SLEEPING,
	WINDING,
}

@export var damage:= 10.0
@export var detection_range:= 300.0
@export var walk_speed:= 50.0
@export var dash_speed:= 300.0
@export var experience_reward:= 10.0
@export var health:= 30.0:
	set(value):
		health = value
		if health <= 0:
			died.emit()

var current_speed:= 0.0
var current_state: EnemyState = EnemyState.IDLE
var dashing_distance: float = 150.0
var dashing_destination: Vector2
var direction: Vector2
var distance_to_player: float
var player_ref: CharacterBody2D = null
var room: Room = null

@onready var hurt_box: HurtBoxComponent = %HurtBoxComponent


func _ready() -> void:
	room = get_parent()  # Assuming the enemy is a child of the room
	if is_instance_valid(room):
		player_ref = room.player
		print("Enemy initialized - Player reference:", player_ref)

	_change_state(EnemyState.IDLE)
	died.connect(_on_died)
	hurt_box.hit_received.connect(_on_hurt_box_hit_received)


func _physics_process(delta) -> void:
	if not player_ref:
		print("No player reference found, cannot follow")
		return
	velocity = direction * current_speed
	_update_state_machine(delta)
	move_and_slide()


func _update_state_machine(_delta):
	match current_state:
		EnemyState.IDLE:
			distance_to_player = global_position.distance_to(player_ref.global_position)
			direction = (player_ref.global_position - global_position).normalized()
			if distance_to_player < detection_range and distance_to_player > 30:
				_change_state(EnemyState.MOVING)

		EnemyState.MOVING:
			distance_to_player = global_position.distance_to(player_ref.global_position)
			direction = (player_ref.global_position - global_position).normalized()
			if distance_to_player < dashing_distance:
				_change_state(EnemyState.WINDING)
			if distance_to_player > detection_range:
				_change_state(EnemyState.IDLE)

		EnemyState.WINDING:
			# add animation
			await get_tree().create_timer(0.5).timeout
			_change_state(EnemyState.DASHING)

		EnemyState.DASHING:
			if global_position.distance_to(dashing_destination) <= 30.0:
				_change_state(EnemyState.SLEEPING)

		EnemyState.SLEEPING:
			# add animation
			await get_tree().create_timer(0.5).timeout
			_change_state(EnemyState.IDLE)


func _change_state(new_state: EnemyState):
	if current_state == new_state:
		return

	_exit_state(current_state)
	print("changing enemy state from ", EnemyState.keys()[current_state], " to ", EnemyState.keys()[new_state])
	current_state = new_state
	_enter_state(new_state)


func _enter_state(state: EnemyState):
	match state:
		EnemyState.IDLE:
			current_speed = 0.0
		EnemyState.MOVING:
			current_speed = walk_speed
		EnemyState.WINDING, EnemyState.SLEEPING:
			current_speed = 0.0
		EnemyState.DASHING:
			current_speed = dash_speed
			var player_position = player_ref.global_position
			dashing_destination = player_position
			direction = global_position.direction_to(player_position)


func _exit_state(state: EnemyState):
	match state:
		EnemyState.IDLE:
			pass
		EnemyState.MOVING:
			pass
		EnemyState.WINDING:
			pass
		EnemyState.DASHING:
			pass
		EnemyState.SLEEPING:
			pass


func _drop_loot() -> void:
	print("Enemy died, dropping loot")
	room.call_deferred(&"spawn_feature", Room.FeatureType.HEALTH_PACK, global_position)


func _give_experience() -> void:
	print("Enemy died, rewarding experience")
	if player_ref:
		player_ref.experience += experience_reward
		print("Player rewarded with", experience_reward, "experience")


func _on_died() -> void:
	_give_experience()
	_drop_loot()
	queue_free()  # Remove enemy from the scene


func _on_hurt_box_hit_received(hit_damage: int) -> void:
	if health <= 0:
		return  # Prevent further processing if already dead

	health -= hit_damage
	print("HurtBoxComponent: Hit received, new health:", health)