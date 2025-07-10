extends Node


func shake(shakeable: Node2D, strength: float, duration: float = 0.2) -> void:
	if not shakeable:
		return

	var original_position:= shakeable.position
	var shake_count:= 10
	var tween:= create_tween()

	for i in shake_count:
		var offset:= Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target:= original_position + strength * offset
		if i % 2 == 0:
			target = original_position
		tween.tween_property(shakeable, "position", target, duration / float(shake_count))
		strength *= 0.75

	tween.finished.connect(func(): shakeable.position = original_position)
	