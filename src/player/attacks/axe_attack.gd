class_name AxeAttack extends Node2D

@export var damage: int = 10
@export var speed: float = 200.0

var direction: Vector2
var current_speed: float = 0.0
var player: Player

@onready var sprite: Sprite2D = %Sprite2D
@onready var hit_box_component: HitBoxComponent = %HitBoxComponent
@onready var interactable_area: Area2D = %InteractableArea
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	current_speed = 0.0
	player = get_tree().get_first_node_in_group("players")
	hit_box_component.parent_node = player
	hit_box_component.damage = damage
	hit_box_component.body_entered.connect(_on_body_entered)
	hit_box_component.hit.connect(func(_area): queue_free())


func _process(delta: float) -> void:
	translate(direction * speed * delta)


func fire() -> void:
	animation_player.play("attack")
	current_speed = speed
	
	# only activate the collision layers when the attack is fired
	# activate the interactables collision layer
	interactable_area.set_collision_layer_value(4, true)
	# activate world and enemy collision layers
	for collision_mask_value in [1, 3]:
		hit_box_component.set_collision_mask_value(collision_mask_value, true)
	
	# avoid physics interpolation issues
	reset_physics_interpolation()


func _on_body_entered(body: Node2D) -> void:
	if body is not TileMapLayer:
		return
	
	print("AxeAttack: Hit body: ", body.name, "of class: ", body.get_class())

	# when the attack collides with a solid TileMapLayer
	# we stop the attack
	set_deferred("direction", Vector2.ZERO)
	# the animation
	animation_player.stop()
	# and make sure we can interact with the attack
	interactable_area.is_interactable = true
	