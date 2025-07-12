# Player.gd
# This script controls the player character's movement, state management, and interactions.
class_name Player extends CharacterBody2D

const AXE_ATTACK_SCENE = preload("res://src/player/attacks/axe_attack.tscn")

signal died

# Player Movement stats
@export var speed: float = 80.0
@export var acceleration: float = 500.0
@export var friction: float = 400.0
@export var attack_cost:= 2.0
@export var attack_refund_cost:= 3.0
@export var heal_rate:= 1.0

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
		if health <= 0:
			died.emit()

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

@export var attack_rate: float:
	set(value):
		attack_rate = max(value, 0.1)  # Ensure attack rate is not too low
		print("Player attack rate set to: ", attack_rate)
		EventBus.player_attack_rate_changed.emit(attack_rate)

@export var attack_damage: int = 10:
	set(value):
		attack_damage = max(value, 1)  # Ensure attack damage is at least 1
		print("Player attack damage set to: ", attack_damage)
		EventBus.player_attack_damage_changed.emit(attack_damage)

var _input_vector: Vector2 = Vector2.ZERO
var _attacking_vector: Vector2 = Vector2.RIGHT
var _attack: Node2D
var _room_manager: Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_cooldown: Timer = %AttackCooldown
@onready var interaction_area: Area2D = %InteractionArea
@onready var sprite_pivot: Marker2D = %SpritePivot
@onready var attack_origin: Marker2D = %AttackOrigin
@onready var state_chart: StateChart = %StateChart
@onready var idling_state: AtomicState = %Idling
@onready var moving_state: AtomicState = %Moving
@onready var interacting_state: AtomicState = %Interacting
@onready var attacking_state: AtomicState = %Attacking
@onready var recharging_state: AtomicState = %Recharging
@onready var hurt_box: HurtBoxComponent = %HurtBoxComponent


func _ready() -> void:
	_initialize_stats()
	_connect_state_chart_events()
	died.connect(_on_died)
	_room_manager = get_tree().get_first_node_in_group("room_manager")


func _physics_process(delta) -> void:
	_input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_attacking_vector = Input.get_vector("attack_left", "attack_right", "attack_up", "attack_down")

	_handle_movement(delta)
	_handle_actions()
	move_and_slide()


func _initialize_stats() -> void:
	max_health = 60
	health = max_health
	experience = 50
	memory_shards = 1
	attack_rate = 0.5
	print("Player initialized")


func _connect_state_chart_events() -> void:
	idling_state.state_entered.connect(_on_idling_state_entered)
	idling_state.state_physics_processing.connect(_on_idling_state_physics_processing)
	moving_state.state_entered.connect(_on_moving_state_entered)
	moving_state.state_physics_processing.connect(_on_moving_state_physics_processing)
	interacting_state.state_entered.connect(_on_interacting_state_entered)
	recharging_state.state_entered.connect(_on_recharging_state_entered)
	attacking_state.state_entered.connect(_on_attacking_state_entered)


func _handle_actions() -> void:
	if Input.is_action_just_pressed("interact"):
		state_chart.send_event("interact")
	if _attacking_vector != Vector2.ZERO:
		state_chart.send_event("attack")


func _handle_movement(delta) -> void:
	var target_velocity: Vector2
	var velocity_rate: float
	if _input_vector != Vector2.ZERO:
		velocity_rate = acceleration
		target_velocity = _input_vector * speed
	else:
		velocity_rate = friction
		target_velocity = Vector2.ZERO

	velocity = velocity.move_toward(target_velocity, velocity_rate * delta)


func _spawn_attack():
	if not attack_origin:
		print("Attack origin marker not found!")
		return

	_attack = AXE_ATTACK_SCENE.instantiate()
	attack_origin.add_child(_attack)


func _play_animation(animation_name: String):
	if animation_player and animation_player.has_animation(animation_name):
		if animation_player.current_animation != animation_name:
			animation_player.play(animation_name)


func _check_for_interactables() -> Array:
	print("Checking for nearby interactable objects...")

	var interactables = interaction_area.get_overlapping_areas()
	if interactables.size() == 0:
		print("No interactable objects nearby.")
		return []
	else:
		return interactables


func _on_died() -> void:
	queue_free()


func _on_idling_state_entered() -> void:
	print("Entering idling state")
	animation_player.speed_scale = 1.0
	_play_animation("idle")
	if velocity.x > 0:
		sprite_pivot.scale.x = 1
	elif velocity.x < 0:
		sprite_pivot.scale.x = -1


func _on_idling_state_physics_processing(_delta: float) -> void:
	if _input_vector != Vector2.ZERO:
		state_chart.send_event("move")


func _on_moving_state_entered() -> void:
	print("Entering moving state")
	animation_player.speed_scale = 2.0
	_play_animation("walking")
	if _input_vector.x > 0:
		sprite_pivot.scale.x = 1
	elif _input_vector.x < 0:
		sprite_pivot.scale.x = -1


func _on_moving_state_physics_processing(_delta: float) -> void:
	if _input_vector == Vector2.ZERO:
		state_chart.send_event("stop_moving")


func _on_recharging_state_entered() -> void:
	print("Entering recharging state")
	_spawn_attack()


func _on_attacking_state_entered() -> void:
	print("Entering attacking state")
	if not is_instance_valid(_attack):
		return

	_attack.direction = _attacking_vector
	_attack.reparent(_room_manager.current_room)
	_attack.fire()

	health -= _attack.damage / attack_cost


func _on_interacting_state_entered() -> void:
	animation_player.speed_scale = 1.0
	_play_animation("interact")
	var interactables = _check_for_interactables()
	if interactables.size() == 0:
		return

	for area in interactables:
		print("Found interactable: ", area.name)
		if area.has_method("interact"):
			area.interact(self)
		else:
			print("Interactable does not have an interact method: ", area.name)
