class_name EntryRoom extends Room


func _ready() -> void:
	print("EntryRoom initialized")
	room_type = RoomType.ENTRY
	super._ready()


func _spawn_room_features() -> void:
	print("EntryRoom spawning features...")
	_spawn_welcome_message()
	var door_dimensions = Vector2(32, 64)
	_spawn_door_to_battle_room(Vector2(640 - (door_dimensions.x / 2.0), 360 / 2.0 - (door_dimensions.y / 2.0)))
	_spawn_door_to_sacrifice_room(Vector2(door_dimensions.x / 2.0, 360 / 2.0 - (door_dimensions.y / 2.0)))


func _spawn_welcome_message() -> void:
	var welcome_message = Label.new()
	welcome_message.text = "Welcome to the Entry Room!"
	welcome_message.position = Vector2(160, 8)  # Centered position
	add_child(welcome_message)


func _spawn_door_to_battle_room(door_position: Vector2) -> void:
	_spawn_door(door_position, RoomType.BATTLE)


func _spawn_door_to_sacrifice_room(door_position: Vector2) -> void:
	_spawn_door(door_position, RoomType.SACRIFICE)
