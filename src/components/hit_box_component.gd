class_name HitBoxComponent extends Area2D

signal hit(hurtbox: HurtBoxComponent)

var damage: int
var parent_node: Node2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	_calculate_damage.call_deferred()


func _calculate_damage() -> void:
	if not parent_node:
		print("HitBoxComponent: No parent node set, cannot calculate damage.")
		return

	damage += parent_node.attack_damage if parent_node.has_method("attack_damage") else 0


func _on_area_entered(area: Area2D) -> void:
	if area is not HurtBoxComponent:
		print("HitBoxComponent: Area entered is not a HurtBoxComponent, ignoring hit.")
		return

	var hurtbox = area as HurtBoxComponent
	hurtbox.take_hit_from(self)
	hit.emit(hurtbox)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		return

	parent_node.stop()
