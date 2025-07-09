class_name EntryRoom extends Room

@onready var door_to_battle_room: Area2D = %DoorToBattleRoom
@onready var door_to_sacrifice_room: Area2D = %DoorToSacrificeRoom


func _ready() -> void:
	print("EntryRoom initialized")
	room_type = RoomType.ENTRY
	door_to_battle_room.body_entered.connect(_on_door_entered.bind(RoomType.BATTLE))
	door_to_sacrifice_room.body_entered.connect(_on_door_entered.bind(RoomType.SACRIFICE))
	super._ready()