class_name Enemy extends CharacterBody2D

signal died

const RED_SPRITE_MATERIAL:= preload("res://src/resources/red_sprite_material.tres")

@export var damage:= 10.0
@export var chasing_detection_range:= 200.0
@export var chasing_speed:= 30.0
@export var experience_reward:= 10.0
@export var health:= 30:
	set(value):
		health = value
		if health <= 0:
			died.emit()

var current_speed:= 0.0
var minimum_chasing_distance:= 30.0
var direction: Vector2
var distance_to_player: float
var player_ref: CharacterBody2D = null
var room: Room = null

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var body_sprite: Sprite2D = %Body
@onready var hurt_box: HurtBoxComponent = %HurtBoxComponent
@onready var state_chart: StateChart = %StateChart
@onready var sleeping_state: AtomicState = %Sleeping
@onready var chasing_state: AtomicState = %Chasing
@onready var damage_indicator_node: Node2D = %DmgIndicatorNode
@onready var damage_indicator_label: Label = %DmgIndicatorLabel


func _ready() -> void:
	room = get_parent()  # Assuming the enemy is a child of the room
	if is_instance_valid(room):
		player_ref = room.player
		print("Enemy initialized - Player reference:", player_ref)

	add_to_group("enemies")
	sleeping_state.state_entered.connect(_on_sleeping_state_entered)
	sleeping_state.physics_state_processing.connect(_on_sleeping_physics_state_processing)
	chasing_state.state_entered.connect(_on_chasing_state_entered)
	chasing_state.physics_state_processing.connect(_on_chasing_physics_state_processing)

	died.connect(_on_died)
	hurt_box.hit_received.connect(_on_hurt_box_hit_received)


func _physics_process(_delta) -> void:
	velocity = direction * current_speed
	move_and_slide()


func _on_sleeping_state_entered() -> void:
	print("Entering sleeping state")
	print("Distance to player= ", distance_to_player)
	animation_player.play("sleeping")
	current_speed = 0.0


func _on_sleeping_physics_state_processing(_delta: float) -> void:
	# Check if player is within detection range
	distance_to_player = global_position.distance_to(player_ref.global_position)

	# Transition to chasing state if player is detected
	# Ensure the player is within detection range
	# and not too close (to avoid immediate chasing)
	if distance_to_player <= chasing_detection_range and distance_to_player > minimum_chasing_distance:
		state_chart.send_event("chase")
		return


func _on_chasing_state_entered() -> void:
	print("Entering chasing state")
	print("Distance to player= ", distance_to_player)
	animation_player.play("chasing")
	current_speed = chasing_speed


func _on_chasing_physics_state_processing(_delta: float) -> void:
	distance_to_player = global_position.distance_to(player_ref.global_position)
	direction = (player_ref.global_position - global_position).normalized()
	if distance_to_player > chasing_detection_range:
		state_chart.send_event("sleep")
		return


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
	queue_free()


func _on_hurt_box_hit_received(hitbox: HitBoxComponent) -> void:
	if health <= 0:
		return

	_flash_and_shake_tween(hitbox)
	_dmg_indicator_tween(hitbox)
	print("HurtBoxComponent: Hit received, new health:", health)


func _flash_and_shake_tween(hitbox: HitBoxComponent) -> void:
	body_sprite.material = RED_SPRITE_MATERIAL
	var tween = create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 8, 0.15))
	tween.tween_interval(0.15)
	tween.finished.connect(func(): body_sprite.material = null)
	health -= hitbox.damage


func _dmg_indicator_tween(hitbox: HitBoxComponent) -> void:
	damage_indicator_node.show()
	damage_indicator_label.text = str(hitbox.damage)
	var dmg_indicator_position = damage_indicator_node.position
	var target_position = dmg_indicator_position + Vector2(0, -8)
	var damage_tween = create_tween()
	damage_tween.tween_property(damage_indicator_node, "position", target_position, 0.1)
	damage_tween.tween_property(damage_indicator_node, "modulate:a", 0.0, 0.2)

	damage_tween.finished.connect(func():
		damage_indicator_node.modulate.a = 1.0
		damage_indicator_node.hide()
		damage_indicator_node.position = dmg_indicator_position
	)
