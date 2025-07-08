class_name HitBoxComponent extends Area2D

signal hit(hurtbox: HurtBoxComponent)

var damage: int


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	assert(area is HurtBoxComponent, "HitBoxComponent can only interact with HurtBoxComponent")

	var hurtbox = area as HurtBoxComponent
	hurtbox.take_hit_from(self)
	hit.emit(hurtbox)
