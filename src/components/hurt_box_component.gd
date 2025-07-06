class_name HurtBoxComponent extends Area2D

signal died

@export var health:= 30.0:
	set(value):
		health = value
		if health <= 0:
			died.emit()

var _is_invulnerable: bool = false:
	set(value):
		_is_invulnerable = value
		if _is_invulnerable:
			print("HurtBoxComponent is now invulnerable")
			monitoring = false  # Stop monitoring collisions when invulnerable
		else:
			monitoring = true  # Resume monitoring collisions when not invulnerable
			print("HurtBoxComponent is no longer invulnerable")

@onready var invuln_timer: Timer = $InvulnTimer


func _ready() -> void:
	print("HurtBoxComponent is ready")
	body_entered.connect(_on_body_entered)
	invuln_timer.timeout.connect(func(): _is_invulnerable = false)


func _on_body_entered(body: Node) -> void:
	if not body.damage:
		print("HurtBoxComponent: body %s is not a valid damage source", body.name)
		return

	print("HurtBoxComponent: Body entered -", body.name)
	print("Damage received:", body.damage)
	health -= body.damage
	invuln_timer.start()