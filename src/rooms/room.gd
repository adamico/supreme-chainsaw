# Base Room class for handling room features spawning
# This class provides the foundation for different room types and their unique features
class_name Room extends TileMapLayer

# Room types enum for extensibility
enum RoomType {
	BATTLE,
	TREASURE
}

# Feature types that can be spawned in rooms
enum FeatureType {
	ENEMY,
	OBSTACLE,
	TREASURE_CHEST,
	COLLECTIBLE,
	HEALTH_PACK
}

@export var room_type: RoomType = RoomType.BATTLE
@export var room_size: Vector2 = Vector2(640, 360)
@export var max_features: int = 5

var spawned_features: Array[Node2D] = []
var feature_spawn_points: Array[Vector2] = []

@onready var player: CharacterBody2D = $Player


func _ready():
	print("Room initialized - Type: ", RoomType.keys()[room_type])
	_setup_room()
	_generate_spawn_points()
	_spawn_room_features()


# Virtual method to be overridden by specific room types
func _spawn_room_features():
	print("Base room spawning features...")
	# This will be overridden by specific room implementations


# Generate potential spawn points for features
func _generate_spawn_points():
	feature_spawn_points.clear()
	
	# Generate a grid of potential spawn points, avoiding the player start position
	var player_pos = player.global_position if player else Vector2(320, 180)
	var spacing = 80
	var margin = 60
	
	for x in range(margin, int(room_size.x) - margin, spacing):
		for y in range(margin, int(room_size.y) - margin, spacing):
			var spawn_point = Vector2(x, y)
			# Avoid spawning too close to player
			if spawn_point.distance_to(player_pos) > 100:
				feature_spawn_points.append(spawn_point)
	
	print("Generated ", feature_spawn_points.size(), " potential spawn points")


# Get a random available spawn point
func _get_random_spawn_point() -> Vector2:
	if feature_spawn_points.is_empty():
		# Fallback to random position if no predefined points
		return Vector2(
			randf_range(60, room_size.x - 60),
			randf_range(60, room_size.y - 60)
		)
	
	var index = randi() % feature_spawn_points.size()
	var point = feature_spawn_points[index]
	feature_spawn_points.remove_at(index)  # Remove used point
	return point


# Spawn a specific feature at a given position
func _spawn_feature(feature_type: FeatureType, spawn_position: Vector2) -> Node2D:
	var feature_node = _create_feature(feature_type)
	if feature_node:
		feature_node.global_position = spawn_position
		add_child(feature_node)
		spawned_features.append(feature_node)
		print("Spawned ", FeatureType.keys()[feature_type], " at ", spawn_position)
	return feature_node


# Create a feature node based on type - to be extended by subclasses
func _create_feature(feature_type: FeatureType) -> Node2D:
	match feature_type:
		FeatureType.OBSTACLE:
			return _create_obstacle()
		FeatureType.COLLECTIBLE:
			return _create_collectible()
		_:
			print("Feature type not implemented in base class: ", FeatureType.keys()[feature_type])
			return null


# Create a basic obstacle (can be overridden)
func _create_obstacle() -> Node2D:
	var obstacle = StaticBody2D.new()
	obstacle.name = "Obstacle"
	
	# Add visual representation
	var sprite = Sprite2D.new()
	sprite.texture = _create_colored_texture(Vector2(32, 32), Color.GRAY)
	obstacle.add_child(sprite)
	
	# Add collision
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(32, 32)
	collision.shape = shape
	obstacle.add_child(collision)
	
	return obstacle


# Create a basic collectible (can be overridden)
func _create_collectible() -> Node2D:
	var collectible = Area2D.new()
	collectible.name = "Collectible"
	
	# Add visual representation
	var sprite = Sprite2D.new()
	sprite.texture = _create_colored_texture(Vector2(16, 16), Color.YELLOW)
	collectible.add_child(sprite)
	
	# Add collision for detection
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(16, 16)
	collision.shape = shape
	collectible.add_child(collision)
	
	# Connect collection signal with the collectible as a parameter
	collectible.body_entered.connect(_on_collectible_collected.bind(collectible))
	
	return collectible


# Handle collectible collection
func _on_collectible_collected(body, collectible):
	if body == player and collectible in spawned_features:
		print("Collectible collected!")
		spawned_features.erase(collectible)
		collectible.queue_free()


# Create a simple colored texture for basic features
func _create_colored_texture(size: Vector2, color: Color) -> ImageTexture:
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGB8)
	image.fill(color)
	var texture = ImageTexture.create_from_image(image)
	return texture


# Setup room-specific properties
func _setup_room():
	# This can be overridden by specific room types for custom setup
	pass


# Public method to get room type
func get_room_type() -> RoomType:
	return room_type


# Public method to get spawned features
func get_spawned_features() -> Array[Node2D]:
	return spawned_features.duplicate()


# Public method to clear all features (useful for room transitions)
func clear_features():
	for feature in spawned_features:
		if is_instance_valid(feature):
			feature.queue_free()
	spawned_features.clear()
	_generate_spawn_points()  # Regenerate spawn points


# Public method to respawn features (useful for room reset)
func respawn_features():
	clear_features()
	await get_tree().process_frame  # Wait for cleanup
	_spawn_room_features()
