extends Room

# TreasureRoom - A room type focused on exploration and collection
# Spawns treasure chests, collectibles, and special items

class_name TreasureRoom

# Treasure room specific configuration
@export var treasure_chest_count: int = 2
@export var collectible_count: int = 5
@export var special_item_count: int = 1

# Treasure values for scoring/progression
var total_treasure_value: int = 0
var collected_treasure_value: int = 0

func _ready():
	room_type = RoomType.TREASURE
	super._ready()

# Override feature spawning for treasure-specific logic
func _spawn_room_features():
	print("TreasureRoom spawning treasure features...")
	
	# Spawn treasure chests (high value items)
	_spawn_treasure_chests()
	
	# Spawn collectibles (coins, gems, etc.)
	_spawn_collectibles()
	
	# Spawn special items (unique/rare items)
	_spawn_special_items()
	
	print("Total treasure value in room: ", total_treasure_value)

func _spawn_treasure_chests():
	print("Spawning ", treasure_chest_count, " treasure chests")
	for i in range(treasure_chest_count):
		if feature_spawn_points.size() > 0:
			var spawn_pos = _get_random_spawn_point()
			_spawn_feature(FeatureType.TREASURE_CHEST, spawn_pos)

func _spawn_collectibles():
	print("Spawning ", collectible_count, " collectibles")
	for i in range(collectible_count):
		if feature_spawn_points.size() > 0:
			var spawn_pos = _get_random_spawn_point()
			_spawn_feature(FeatureType.COLLECTIBLE, spawn_pos)

func _spawn_special_items():
	print("Spawning ", special_item_count, " special items")
	for i in range(special_item_count):
		if feature_spawn_points.size() > 0:
			var spawn_pos = _get_random_spawn_point()
			# Special items use a custom feature type
			_spawn_special_item(spawn_pos)

# Override feature creation for treasure-specific features
func _create_feature(feature_type: FeatureType) -> Node2D:
	match feature_type:
		FeatureType.TREASURE_CHEST:
			return _create_treasure_chest()
		FeatureType.COLLECTIBLE:
			return _create_treasure_collectible()  # Enhanced version
		_:
			# Fall back to base class for common features
			return super._create_feature(feature_type)

# Create a treasure chest
func _create_treasure_chest() -> Node2D:
	var chest = Area2D.new()
	chest.name = "TreasureChest"
	
	# Add visual representation - brown chest
	var sprite = Sprite2D.new()
	sprite.texture = _create_chest_texture()
	chest.add_child(sprite)
	
	# Add collision for detection
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(32, 24)
	collision.shape = shape
	chest.add_child(collision)
	
	# Add treasure value
	var treasure_value = randi_range(50, 100)
	chest.set_meta("treasure_value", treasure_value)
	total_treasure_value += treasure_value
	
	# Connect interaction signal
	chest.body_entered.connect(_on_treasure_chest_opened)
	
	return chest

# Create enhanced collectible for treasure room
func _create_treasure_collectible() -> Node2D:
	var collectible = Area2D.new()
	collectible.name = "TreasureCollectible"
	
	# Random collectible type
	var collectible_types = ["coin", "gem", "ring"]
	var type = collectible_types[randi() % collectible_types.size()]
	
	# Add visual representation based on type
	var sprite = Sprite2D.new()
	var color = Color.YELLOW
	match type:
		"coin":
			color = Color.GOLD
		"gem":
			color = Color.CYAN
		"ring":
			color = Color.MAGENTA
	
	sprite.texture = _create_colored_texture(Vector2(12, 12), color)
	collectible.add_child(sprite)
	
	# Add collision for detection
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 8
	collision.shape = shape
	collectible.add_child(collision)
	
	# Add treasure value based on type
	var treasure_value = _get_collectible_value(type)
	collectible.set_meta("treasure_value", treasure_value)
	collectible.set_meta("collectible_type", type)
	total_treasure_value += treasure_value
	
	# Connect collection signal
	collectible.body_entered.connect(_on_treasure_collected)
	
	return collectible

# Spawn a special item with unique properties
func _spawn_special_item(position: Vector2):
	var special_item = Area2D.new()
	special_item.name = "SpecialItem"
	
	# Add visual representation - glowing purple item
	var sprite = Sprite2D.new()
	sprite.texture = _create_special_item_texture()
	special_item.add_child(sprite)
	
	# Add collision for detection
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(20, 20)
	collision.shape = shape
	special_item.add_child(collision)
	
	# Special items have high value and unique effects
	var treasure_value = randi_range(200, 300)
	special_item.set_meta("treasure_value", treasure_value)
	special_item.set_meta("item_type", "special")
	total_treasure_value += treasure_value
	
	# Add glowing effect
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(sprite, "modulate:a", 0.5, 1.0)
	tween.tween_property(sprite, "modulate:a", 1.0, 1.0)
	
	special_item.global_position = position
	add_child(special_item)
	spawned_features.append(special_item)
	
	# Connect collection signal
	special_item.body_entered.connect(_on_special_item_collected)

# Get value for different collectible types
func _get_collectible_value(type: String) -> int:
	match type:
		"coin":
			return randi_range(5, 15)
		"gem":
			return randi_range(15, 25)
		"ring":
			return randi_range(25, 35)
		_:
			return 10

# Create a chest texture
func _create_chest_texture() -> ImageTexture:
	var image = Image.create(32, 24, false, Image.FORMAT_RGB8)
	image.fill(Color(0.6, 0.4, 0.2))  # Brown color
	
	# Add some details (simple lock)
	for x in range(14, 18):
		for y in range(10, 14):
			image.set_pixel(x, y, Color.GOLD)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture

# Create a special item texture with gradient effect
func _create_special_item_texture() -> ImageTexture:
	var image = Image.create(20, 20, false, Image.FORMAT_RGB8)
	
	# Create a gradient from purple to white
	for x in range(20):
		for y in range(20):
			var distance_from_center = Vector2(x - 10, y - 10).length()
			var intensity = 1.0 - (distance_from_center / 10.0)
			intensity = clamp(intensity, 0.0, 1.0)
			var color = Color.PURPLE.lerp(Color.WHITE, intensity * 0.5)
			image.set_pixel(x, y, color)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture

# Handle treasure chest opening
func _on_treasure_chest_opened(body):
	if body == player:
		var chest = body.get_parent() if body.get_parent() is Area2D else null
		if chest and chest in spawned_features:
			var treasure_value = chest.get_meta("treasure_value", 0)
			collected_treasure_value += treasure_value
			print("Treasure chest opened! Found treasure worth ", treasure_value, " points!")
			print("Total collected: ", collected_treasure_value, "/", total_treasure_value)
			
			spawned_features.erase(chest)
			chest.queue_free()

# Handle regular treasure collection
func _on_treasure_collected(body):
	if body == player:
		var treasure = body.get_parent() if body.get_parent() is Area2D else null
		if treasure and treasure in spawned_features:
			var treasure_value = treasure.get_meta("treasure_value", 0)
			var treasure_type = treasure.get_meta("collectible_type", "unknown")
			collected_treasure_value += treasure_value
			print("Collected ", treasure_type, " worth ", treasure_value, " points!")
			print("Total collected: ", collected_treasure_value, "/", total_treasure_value)
			
			spawned_features.erase(treasure)
			treasure.queue_free()

# Handle special item collection
func _on_special_item_collected(body):
	if body == player:
		var item = body.get_parent() if body.get_parent() is Area2D else null
		if item and item in spawned_features:
			var treasure_value = item.get_meta("treasure_value", 0)
			collected_treasure_value += treasure_value
			print("SPECIAL ITEM FOUND! Rare treasure worth ", treasure_value, " points!")
			print("Total collected: ", collected_treasure_value, "/", total_treasure_value)
			
			spawned_features.erase(item)
			item.queue_free()

# Override room setup for treasure-specific configuration
func _setup_room():
	print("Setting up TreasureRoom...")
	# Could add treasure-specific room modifications here
	# For example: golden lighting, sparkle effects, etc.

# Public method to check if all treasure has been collected
func is_treasure_room_complete() -> bool:
	return collected_treasure_value >= total_treasure_value

# Public method to get collection progress
func get_collection_progress() -> float:
	if total_treasure_value == 0:
		return 1.0
	return float(collected_treasure_value) / float(total_treasure_value)