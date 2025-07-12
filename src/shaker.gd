class_name Shaker extends RefCounted

var shakeable: Node2D
var starting_position: Vector2
var number_of_shakes:= 4

func _init(node: Node2D) -> void:
	shakeable = node
	starting_position = shakeable.position


func shake(strength: float, duration: float) -> void:
	for i in number_of_shakes:
		shakeable.position = starting_position + Vector2(randf_range(-strength, strength), randf_range(-strength, strength))
		await shakeable.get_tree().create_timer(duration / number_of_shakes).timeout
		strength -= (strength / number_of_shakes)

	shakeable.position = starting_position