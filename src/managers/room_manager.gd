# RoomManager - Handles switching between different room types
# This demonstrates the extensible room system
class_name RoomManager extends Node2D

# Room scene resources
const ENTRY_ROOM_SCENE = preload("res://src/rooms/entry_room.tscn")
const BATTLE_ROOM_SCENE = preload("res://src/rooms/battle_room.tscn")
const SACRIFICE_ROOM_SCENE = preload("res://src/rooms/sacrifice_room.tscn")


# Current room instance
var current_room: Room = null


func _ready():
	print("RoomManager initialized")
	load_room_by_type(Room.RoomType.ENTRY)


func _load_random_room():
	var room_types = [Room.RoomType.BATTLE, Room.RoomType.SACRIFICE]
	var selected_type = room_types[randi() % room_types.size()]
	load_room_by_type(selected_type)


func load_room_by_type(room_type: Room.RoomType):
	# Clear current room
	if current_room:
		current_room.queue_free()
		current_room = null

	# Load new room scene based on type
	var room_scene: PackedScene
	match room_type:
		Room.RoomType.BATTLE:
			room_scene = BATTLE_ROOM_SCENE
			print("Loading BattleRoom...")
		Room.RoomType.ENTRY:
			room_scene = ENTRY_ROOM_SCENE
			print("Loading EntryRoom...")
		Room.RoomType.SACRIFICE:
			room_scene = SACRIFICE_ROOM_SCENE
			print("Loading SacrificeRoom...")
		_:
			print("Unknown room type: ", room_type)
			return

	# Instantiate and add the new room
	var room_instance = room_scene.instantiate()
	call_deferred(&"add_child", room_instance)
	current_room = room_instance

	print("Room loaded successfully: ", Room.RoomType.keys()[room_type])


# Public method to manually switch rooms
func switch_to_battle_room():
	load_room_by_type(Room.RoomType.BATTLE)


func switch_to_sacrifice_room():
	load_room_by_type(Room.RoomType.SACRIFICE)


# Public method to get current room
func get_current_room() -> Room:
	return current_room
