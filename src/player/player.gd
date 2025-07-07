# Player.gd
# This script controls the player character's movement, state management, and interactions.
class_name Player extends CharacterBody2D

# State enum for state machine
enum PlayerState {
	IDLE,
	MOVING,
	INTERACTING
}

# Player Movement stats
@export var speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 1000.0

# Player stats
@export var max_health: int:
	set(value):
		var current_max_health = max_health
		max_health = max(value, 1)
		print("Player max health set to: ", max_health)
		# increase current health by the same amount
		health += (max_health - current_max_health)

@export var health: int:
	set(value):
		health = clamp(value, 0, max_health)
		print("Player health changed to: ", health)
		EventBus.player_health_changed.emit(health, max_health)

@export var experience: int:
	set(value):
		experience = max(value, 0)
		print("Player experience changed to: ", experience)
		EventBus.player_experience_changed.emit(experience)

@export var memory_shards: int:
	set(value):
		memory_shards = max(value, 0)
		print("Player memory shards changed to: ", memory_shards)
		EventBus.player_memory_shards_changed.emit(memory_shards)

@export var damage: float = 10.0

var current_state: PlayerState = PlayerState.IDLE
var input_vector: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea


func _ready() -> void:
	# Initialize player stats
	health = 100
	experience = 50
	memory_shards = 1
	_change_state(PlayerState.IDLE)
	print("Player initialized")


func _physics_process(delta) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_handle_input()
	_handle_movement(delta)
	_update_state_machine(delta)
	_update_sprite_animation()
	move_and_slide()


func _handle_input() -> void:
	if Input.is_action_just_pressed("interact"):
		_perform_interact()


func _handle_movement(delta) -> void:
	var target_velocity: Vector2
	var velocity_rate: float
	if input_vector != Vector2.ZERO:
		velocity_rate = acceleration
		target_velocity = input_vector * speed
	else:
		velocity_rate = friction
		target_velocity = Vector2.ZERO

	velocity = velocity.move_toward(target_velocity, velocity_rate * delta)


func _update_state_machine(_delta):
	match current_state:
		PlayerState.IDLE:
			if input_vector != Vector2.ZERO:
				_change_state(PlayerState.MOVING)

		PlayerState.MOVING:
			if input_vector == Vector2.ZERO:
				_change_state(PlayerState.IDLE)

		PlayerState.INTERACTING:
			await get_tree().create_timer(0.5).timeout
			if input_vector != Vector2.ZERO:
				_change_state(PlayerState.MOVING)
			else:
				_change_state(PlayerState.IDLE)


func _change_state(new_state: PlayerState):
	if current_state == new_state:
		return

	_exit_state(current_state)

	current_state = new_state
	print("Player state changed to: ", PlayerState.keys()[current_state])

	_enter_state(new_state)


func _enter_state(state: PlayerState):
	match state:
		PlayerState.IDLE:
			pass
		PlayerState.MOVING:
			pass
		PlayerState.INTERACTING:
			print("Player is interacting!")


func _exit_state(state: PlayerState):
	match state:
		PlayerState.IDLE:
			pass
		PlayerState.MOVING:
			pass
		PlayerState.INTERACTING:
			pass


func _update_sprite_animation():
	if not sprite:
		return

	match current_state:
		PlayerState.IDLE:
			_play_animation("idle")
			if velocity.x > 0:
				sprite.flip_h = false
			elif velocity.x < 0:
				sprite.flip_h = true

		PlayerState.MOVING:
			_play_animation("walk")
			if input_vector.x > 0:
				sprite.flip_h = false
			elif input_vector.x < 0:
				sprite.flip_h = true

		PlayerState.INTERACTING:
			_play_animation("interact")


func _play_animation(animation_name: String):
	if animation_player and animation_player.has_animation(animation_name):
		if animation_player.current_animation != animation_name:
			animation_player.play(animation_name)


func _perform_interact():
	print("Interact action triggered!")

	if current_state != PlayerState.INTERACTING:
		_change_state(PlayerState.INTERACTING)

	# Here you can add specific interaction logic:
	# - Check for nearby objects to interact with
	# - Trigger dialogue systems
	# - Open inventory
	# - Use items
	# - etc.

	# Example: Look for interactable objects in range
	_check_for_interactables()


func _check_for_interactables() -> void:
	print("Checking for nearby interactable objects...")

	var interactables = interaction_area.get_overlapping_bodies()
	if interactables.size() == 0:
		print("No interactable objects nearby.")
		return
	else:
		for body in interactables:
			if body.has_method("interact"):
				body.interact()
			else:
				print("Interactable does not have an interact method: ", body.name)


# Public method to get current player state (useful for other systems)
func get_current_state() -> PlayerState:
	return current_state


# Public method to check if player is moving
func is_moving() -> bool:
	return current_state == PlayerState.MOVING


# Public method to check if player can interact
func can_interact() -> bool:
	return current_state != PlayerState.INTERACTING


# Public method to force state change (useful for cutscenes, etc.)
func force_state_change(new_state: PlayerState):
	_change_state(new_state)
