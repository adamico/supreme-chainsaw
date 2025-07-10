class_name AxeAttack extends Node2D

@export var damage: int = 10
@export var speed: float = 200.0

var direction: Vector2
var current_speed: float = 0.0

@onready var sprite: Sprite2D = %Sprite2D
@onready var hit_box_component: HitBoxComponent = %HitBoxComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	current_speed = 0.0
	hit_box_component.damage = damage
	hit_box_component.parent_node = self
	hit_box_component.hit.connect(func(_area): queue_free())


func _process(delta: float) -> void:
	translate(direction * speed * delta)


func fire() -> void:
	animation_player.play("attack")
	current_speed = speed
	reset_physics_interpolation()


func stop() -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	