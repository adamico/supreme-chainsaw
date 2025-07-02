extends CharacterBody2D

# Player script for movement, interaction, and state management

# Movement constants
const SPEED = 300.0
const ACCELERATION = 1500.0
const FRICTION = 1000.0

# State enum for state machine
enum PlayerState {
	IDLE,
	MOVING,
	INTERACTING
}

# Current state
var current_state: PlayerState = PlayerState.IDLE

# Animation and sprite references
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Input vector
var input_vector: Vector2 = Vector2.ZERO

func _ready():
	# Initialize the player
	print("Player initialized")
	_change_state(PlayerState.IDLE)

func _physics_process(delta):
	# Handle input
	_handle_input()
	
	# Update state machine
	_update_state_machine(delta)
	
	# Handle movement
	_handle_movement(delta)
	
	# Update sprite/animation
	_update_sprite_animation()
	
	# Move the character
	move_and_slide()

func _handle_input():
	# Get movement input using Input.get_vector() for automatic normalization
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Handle interact action
	if Input.is_action_just_pressed("interact"):
		_perform_interact()

func _handle_movement(delta):
	# Apply movement based on input
	if input_vector != Vector2.ZERO:
		# Accelerate towards target velocity
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		# Apply friction when no input
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func _update_state_machine(delta):
	match current_state:
		PlayerState.IDLE:
			if input_vector != Vector2.ZERO:
				_change_state(PlayerState.MOVING)
		
		PlayerState.MOVING:
			if input_vector == Vector2.ZERO:
				_change_state(PlayerState.IDLE)
		
		PlayerState.INTERACTING:
			# Interaction state with a simple timer to return to idle
			await get_tree().create_timer(0.5).timeout
			if input_vector != Vector2.ZERO:
				_change_state(PlayerState.MOVING)
			else:
				_change_state(PlayerState.IDLE)

func _change_state(new_state: PlayerState):
	if current_state == new_state:
		return
	
	# Exit current state
	_exit_state(current_state)
	
	# Change to new state
	current_state = new_state
	print("Player state changed to: ", PlayerState.keys()[current_state])
	
	# Enter new state
	_enter_state(new_state)

func _enter_state(state: PlayerState):
	match state:
		PlayerState.IDLE:
			pass  # Nothing special needed for idle
		PlayerState.MOVING:
			pass  # Nothing special needed for moving
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
	# Update sprite/animation based on current state and movement
	if not sprite:
		return
	
	match current_state:
		PlayerState.IDLE:
			_play_animation("idle")
			# Face the last movement direction or default
			if velocity.x > 0:
				sprite.flip_h = false
			elif velocity.x < 0:
				sprite.flip_h = true
		
		PlayerState.MOVING:
			_play_animation("walk")
			# Flip sprite based on movement direction
			if input_vector.x > 0:
				sprite.flip_h = false
			elif input_vector.x < 0:
				sprite.flip_h = true
		
		PlayerState.INTERACTING:
			_play_animation("interact")

func _play_animation(animation_name: String):
	# Play animation if AnimationPlayer exists and has the animation
	if animation_player and animation_player.has_animation(animation_name):
		if animation_player.current_animation != animation_name:
			animation_player.play(animation_name)
	else:
		# Fallback: just print the animation name if no AnimationPlayer
		print("Playing animation: ", animation_name)

func _perform_interact():
	# Perform interact action
	print("Interact action triggered!")
	
	# Change to interacting state if not already interacting
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

func _check_for_interactables():
	# Example interaction detection
	# This would typically use Area2D detection or raycasting
	print("Checking for nearby interactable objects...")
	
	# Placeholder for interaction logic
	# In a real game, you might:
	# 1. Use get_overlapping_bodies() on an Area2D
	# 2. Raycast in the facing direction
	# 3. Check distance to known interactable objects
	# 4. Show interaction prompts to the player

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