class_name HitBoxComponent extends Area2D

signal hit(hurtbox: HurtBoxComponent)

var damage: int
var player: Node2D
var knock_back: float

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	player = get_tree().get_first_node_in_group("players")
	if not player:
		print("HitBoxComponent: No parent node set, cannot calculate damage.")
		return

	_calculate_damage.call_deferred()
	_calculate_knock_back_strength.call_deferred()


func _calculate_damage() -> void:
	damage += player.attack_damage if player.has_method("attack_damage") else 0


func _calculate_knock_back_strength() -> void:
	knock_back += player.knock_back_strength if player.has_method("knock_back_strength") else 0


func _on_area_entered(area: Area2D) -> void:
	if area is not HurtBoxComponent:
		print("HitBoxComponent: Area entered is not a HurtBoxComponent, ignoring hit.")
		return

	var hurtbox = area as HurtBoxComponent
	hurtbox.take_hit_from(self)
	hit.emit(hurtbox)

