class_name AxeAttack extends Node2D

@export var damage: int = 10

var direction: Vector2
var speed: float = 300.0

@onready var sprite: Sprite2D = %Sprite2D
@onready var hit_box_component: HitBoxComponent = %HitBoxComponent

func _ready() -> void:
	hit_box_component.damage = damage
	hit_box_component.parent_node = self
	hit_box_component.hit.connect(func(_area): queue_free())


func _process(delta: float) -> void:
	translate(direction * speed * delta)
	_update_sprite()


func _update_sprite() -> void:
	if direction.x > 0:
		sprite.scale.x = 1  # Facing right
	elif direction.x < 0:
		sprite.scale.x = -1  # Facing left
	else:
		sprite.scale.x = 1  # Default scale for vertical attacks
