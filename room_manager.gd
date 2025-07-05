extends Node2D

# RoomManager - Handles switching between different room types
# This demonstrates the extensible room system

class_name RoomManager

# Room scene resources
const BATTLE_ROOM_SCENE = preload("res://battle_room.tscn")
const TREASURE_ROOM_SCENE = preload("res://treasure_room.tscn")

# Current room instance
var current_room: Room = null

# Room switching
@export var auto_switch_rooms: bool = true
@export var room_switch_delay: float = 10.0

func _ready():
	print("RoomManager initialized")
	_load_random_room()
	
	if auto_switch_rooms:
		_start_room_switching_timer()

# Load a random room type
func _load_random_room():
	var room_types = [Room.RoomType.BATTLE, Room.RoomType.TREASURE]
	var selected_type = room_types[randi() % room_types.size()]
	load_room_by_type(selected_type)

# Load a specific room type
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
		Room.RoomType.TREASURE:
			room_scene = TREASURE_ROOM_SCENE
			print("Loading TreasureRoom...")
		_:
			print("Unknown room type: ", room_type)
			return
	
	# Instantiate and add the new room
	var room_instance = room_scene.instantiate()
	add_child(room_instance)
	current_room = room_instance
	
	print("Room loaded successfully: ", Room.RoomType.keys()[room_type])

# Start automatic room switching timer
func _start_room_switching_timer():
	var timer = Timer.new()
	timer.wait_time = room_switch_delay
	timer.timeout.connect(_on_switch_timer_timeout)
	timer.autostart = true
	add_child(timer)
	print("Auto room switching enabled - will switch every ", room_switch_delay, " seconds")

# Handle automatic room switching
func _on_switch_timer_timeout():
	print("Auto-switching to a new room...")
	_load_random_room()

# Public method to manually switch rooms
func switch_to_battle_room():
	load_room_by_type(Room.RoomType.BATTLE)

func switch_to_treasure_room():
	load_room_by_type(Room.RoomType.TREASURE)

# Public method to get current room
func get_current_room() -> Room:
	return current_room

# Handle input for manual room switching (for testing)
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Enter key
		print("Manual room switch triggered!")
		_load_random_room()
	elif event.is_action_pressed("ui_select"):  # Space key (if interact is taken)
		if current_room:
			current_room.respawn_features()
			print("Room features respawned!")