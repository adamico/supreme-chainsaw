# Room System Usage Guide

## Quick Start

### Using the Room System in Your Project

1. **Basic Room Setup**
   ```gdscript
   # Load a specific room type
   var battle_room = preload("res://battle_room.tscn").instantiate()
   add_child(battle_room)
   ```

2. **Using RoomManager for Dynamic Switching**
   ```gdscript
   # Set main_with_rooms.tscn as your main scene
   # Or create a RoomManager instance:
   var room_manager = RoomManager.new()
   add_child(room_manager)
   
   # Switch rooms programmatically
   room_manager.switch_to_battle_room()
   room_manager.switch_to_treasure_room()
   ```

3. **Accessing Room Features**
   ```gdscript
   var current_room = room_manager.get_current_room()
   var features = current_room.get_spawned_features()
   print("Room has ", features.size(), " features")
   ```

## Creating Custom Room Types

### 1. Create the Script
```gdscript
extends Room
class_name MyCustomRoom

@export var custom_feature_count: int = 3

func _ready():
	room_type = RoomType.BATTLE  # or create new enum value
	super._ready()

func _spawn_room_features():
	print("Spawning custom room features...")
	for i in range(custom_feature_count):
		if feature_spawn_points.size() > 0:
			var spawn_pos = _get_random_spawn_point()
			_spawn_custom_feature(spawn_pos)

func _spawn_custom_feature(position: Vector2):
	# Create your custom feature here
	var feature = _create_my_feature()
	if feature:
		feature.global_position = position
		add_child(feature)
		spawned_features.append(feature)

func _create_my_feature() -> Node2D:
	# Implement your custom feature creation
	var feature = Area2D.new()
	# ... add sprites, collision, logic
	return feature
```

### 2. Create the Scene File
Create a `.tscn` file with:
- Root node: `TileMapLayer` (or extend the Room type)
- Script: Your custom room script
- Player instance as child

### 3. Add to RoomManager (Optional)
```gdscript
# In room_manager.gd, add your room:
const MY_CUSTOM_ROOM_SCENE = preload("res://my_custom_room.tscn")

# Add to the enum in room.gd:
enum RoomType {
	BATTLE,
	TREASURE,
	MY_CUSTOM  # Your new type
}
```

## Room Configuration

### Export Variables
Each room type can be configured via export variables:

```gdscript
# BattleRoom
@export var enemy_count: int = 3
@export var obstacle_count: int = 2
@export var health_pack_count: int = 1

# TreasureRoom
@export var treasure_chest_count: int = 2
@export var collectible_count: int = 5
@export var special_item_count: int = 1

# Base Room
@export var room_type: RoomType = RoomType.BATTLE
@export var room_size: Vector2 = Vector2(640, 360)
@export var max_features: int = 5
```

### Runtime Configuration
```gdscript
# Access room and modify spawn counts
var battle_room = current_room as BattleRoom
if battle_room:
	battle_room.enemy_count = 5  # More enemies!
	battle_room.respawn_features()  # Apply changes
```

## Feature Creation Examples

### Custom Enemy with Unique Behavior
```gdscript
func _create_custom_enemy() -> Node2D:
	var enemy = Enemy.new()
	enemy.speed = 75.0  # Faster enemy
	enemy.detection_range = 200.0  # Longer range
	
	# Custom sprite
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://my_enemy_sprite.png")
	enemy.add_child(sprite)
	
	return enemy
```

### Interactive Feature with Custom Logic
```gdscript
func _create_puzzle_door() -> Node2D:
	var door = StaticBody2D.new()
	door.name = "PuzzleDoor"
	
	# Add visual and collision
	var sprite = Sprite2D.new()
	sprite.texture = _create_colored_texture(Vector2(32, 64), Color.BROWN)
	door.add_child(sprite)
	
	# Add interaction area
	var interaction_area = Area2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(40, 70)
	interaction_area.add_child(collision)
	door.add_child(interaction_area)
	
	# Connect interaction
	interaction_area.body_entered.connect(_on_door_approached.bind(door))
	
	return door

func _on_door_approached(body, door):
	if body == player:
		print("Puzzle door activated!")
		# Add puzzle logic here
```

## Testing Your Rooms

### Use the Test System
```gdscript
# Add the test scene to your project
var test_scene = preload("res://room_system_test.tscn").instantiate()
add_child(test_scene)

# Or run tests programmatically
var test_runner = RoomSystemTest.new()
add_child(test_runner)
await test_runner.run_full_test()
```

### Manual Testing Checklist
- [ ] Room loads without errors
- [ ] Features spawn in correct quantities
- [ ] Player can interact with features
- [ ] Features respond correctly to interaction
- [ ] Room can be cleared and respawned
- [ ] Performance is acceptable with expected feature counts

## Performance Considerations

### Optimization Tips
1. **Limit feature counts** for better performance
2. **Use object pooling** for frequently spawned/destroyed features
3. **Implement feature culling** for large rooms
4. **Cache textures** instead of creating them repeatedly

### Example: Object Pooling
```gdscript
# In your custom room
var enemy_pool: Array[Enemy] = []

func _get_pooled_enemy() -> Enemy:
	if enemy_pool.is_empty():
		return Enemy.new()
	else:
		return enemy_pool.pop_back()

func _return_enemy_to_pool(enemy: Enemy):
	enemy.get_parent().remove_child(enemy)
	enemy_pool.append(enemy)
```

## Debugging and Troubleshooting

### Common Issues
1. **Features not spawning**: Check spawn point generation and feature counts
2. **Signal not connecting**: Verify signal names and binding syntax
3. **Player reference null**: Ensure Player node is child of room
4. **Performance issues**: Reduce feature counts or implement culling

### Debug Helpers
```gdscript
# Add to your room for debugging
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		print("=== Room Debug Info ===")
		print("Room type: ", RoomType.keys()[room_type])
		print("Spawned features: ", spawned_features.size())
		print("Available spawn points: ", feature_spawn_points.size())
		for feature in spawned_features:
			print("- ", feature.name, " at ", feature.global_position)
```

This Room system provides a solid foundation for creating diverse, feature-rich game rooms while maintaining clean, extensible code architecture.
