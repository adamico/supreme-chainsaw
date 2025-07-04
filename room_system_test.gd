extends Node

# Simple test script to validate Room system functionality
# This can be attached to any scene to test room features programmatically

class_name RoomSystemTest

func _ready():
	print("=== Room System Test Started ===")
	_test_room_creation()
	_test_feature_spawning()
	_test_room_types()
	print("=== Room System Test Completed ===")

# Test basic room creation and setup
func _test_room_creation():
	print("\n--- Testing Room Creation ---")
	
	# Test base room
	var base_room = Room.new()
	base_room.name = "TestRoom"
	add_child(base_room)
	
	print("✓ Base Room created successfully")
	print("  Room type: ", Room.RoomType.keys()[base_room.get_room_type()])
	print("  Max features: ", base_room.max_features)
	
	base_room.queue_free()

# Test feature spawning capabilities
func _test_feature_spawning():
	print("\n--- Testing Feature Spawning ---")
	
	var battle_room = BattleRoom.new()
	battle_room.name = "TestBattleRoom"
	add_child(battle_room)
	
	# Wait a frame for room to initialize
	await get_tree().process_frame
	
	var spawned_features = battle_room.get_spawned_features()
	print("✓ BattleRoom spawned ", spawned_features.size(), " features")
	
	# Test feature types
	var feature_types = {}
	for feature in spawned_features:
		var type = feature.name
		if type in feature_types:
			feature_types[type] += 1
		else:
			feature_types[type] = 1
	
	for type in feature_types:
		print("  - ", type, ": ", feature_types[type])
	
	battle_room.queue_free()

# Test different room types
func _test_room_types():
	print("\n--- Testing Room Types ---")
	
	# Test TreasureRoom
	var treasure_room = TreasureRoom.new()
	treasure_room.name = "TestTreasureRoom"
	add_child(treasure_room)
	
	await get_tree().process_frame
	
	var features = treasure_room.get_spawned_features()
	print("✓ TreasureRoom spawned ", features.size(), " features")
	print("  Collection progress: ", treasure_room.get_collection_progress() * 100, "%")
	print("  Room complete: ", treasure_room.is_treasure_room_complete())
	
	treasure_room.queue_free()
	
	print("\n--- Room Type Validation ---")
	_validate_room_enums()

# Validate that room enums are properly defined
func _validate_room_enums():
	print("Available Room Types:")
	for i in Room.RoomType.size():
		print("  ", i, ": ", Room.RoomType.keys()[i])
	
	print("Available Feature Types:")
	for i in Room.FeatureType.size():
		print("  ", i, ": ", Room.FeatureType.keys()[i])

# Test room clearing and respawning
func _test_room_reset():
	print("\n--- Testing Room Reset ---")
	
	var room = BattleRoom.new()
	room.name = "ResetTestRoom"
	add_child(room)
	
	await get_tree().process_frame
	
	var initial_count = room.get_spawned_features().size()
	print("Initial features: ", initial_count)
	
	room.clear_features()
	await get_tree().process_frame
	
	var cleared_count = room.get_spawned_features().size()
	print("After clearing: ", cleared_count)
	
	room.respawn_features()
	await get_tree().process_frame
	
	var respawned_count = room.get_spawned_features().size()
	print("After respawning: ", respawned_count)
	
	room.queue_free()

# Method to run all tests
func run_full_test():
	_test_room_creation()
	await get_tree().process_frame
	_test_feature_spawning()
	await get_tree().process_frame
	_test_room_types()
	await get_tree().process_frame
	_test_room_reset()