class_name HurtBoxComponent extends Area2D

signal hit_received(hitbox: HitBoxComponent)

var _is_invulnerable:= false:
	set(value):
		_is_invulnerable = value
		set_deferred("disabled", _is_invulnerable)


func take_hit_from(hitbox: HitBoxComponent) -> void:
	if _is_invulnerable:
		print("HurtBoxComponent is invulnerable, ignoring hit from", hitbox.name)
		return

	hit_received.emit(hitbox)
	print("HurtBoxComponent: Hit received from", hitbox.name, "with damage:", hitbox.damage)
