# SacrificeRoom - A room where players can make sacrifices for power
class_name SacrificeRoom extends Room

@onready var sacrifice_shrine: SacrificeShrine = %SacrificeShrine


func _ready() -> void:
	room_type = RoomType.SACRIFICE
	EventBus.player_entered_sacrifice_room.emit()
	sacrifice_shrine.player = player

	super._ready()
