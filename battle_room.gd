extends Room

# BattleRoom - A room type focused on combat encounters
# Spawns enemies, obstacles, and health packs

class_name BattleRoom

# Battle room specific configuration
@export var enemy_count: int = 3
@export var obstacle_count: int = 2
@export var health_pack_count: int = 1

func _ready():
	room_type = RoomType.BATTLE
	super._ready()

# Override feature spawning for battle-specific logic
func _spawn_room_features():
	print("BattleRoom spawning combat features...")
	
	# Spawn enemies
	_spawn_enemies()
	
	# Spawn obstacles for cover/tactical gameplay
	_spawn_obstacles()
	
	# Spawn health packs
	_spawn_health_packs()

func _spawn_enemies():
	print("Spawning ", enemy_count, " enemies")
	for i in range(enemy_count):
		if feature_spawn_points.size() > 0:
			var spawn_pos = _get_random_spawn_point()
			_spawn_feature(FeatureType.ENEMY, spawn_pos)

func _spawn_obstacles():
	print("Spawning ", obstacle_count, " obstacles")
	for i in range(obstacle_count):
		if feature_spawn_points.size() > 0:
			var spawn_pos = _get_random_spawn_point()
			_spawn_feature(FeatureType.OBSTACLE, spawn_pos)

func _spawn_health_packs():
	print("Spawning ", health_pack_count, " health packs")
	for i in range(health_pack_count):
		if feature_spawn_points.size() > 0:
			var spawn_pos = _get_random_spawn_point()
			_spawn_feature(FeatureType.HEALTH_PACK, spawn_pos)

# Override feature creation for battle-specific features
func _create_feature(feature_type: FeatureType) -> Node2D:
	match feature_type:
		FeatureType.ENEMY:
			return _create_enemy()
		FeatureType.HEALTH_PACK:
			return _create_health_pack()
		_:
			# Fall back to base class for common features
			return super._create_feature(feature_type)

# Create an enemy
func _create_enemy() -> Node2D:
	var enemy = Enemy.new()
	enemy.name = "Enemy"
	
	# Add visual representation - red square for enemy
	var sprite = Sprite2D.new()
	sprite.texture = _create_colored_texture(Vector2(24, 24), Color.RED)
	enemy.add_child(sprite)
	
	# Add collision
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(24, 24)
	collision.shape = shape
	enemy.add_child(collision)
	
	# Set player reference
	if player:
		enemy.set_player_reference(player)
	
	return enemy

# Create a health pack
func _create_health_pack() -> Node2D:
	var health_pack = Area2D.new()
	health_pack.name = "HealthPack"
	
	# Add visual representation - green cross
	var sprite = Sprite2D.new()
	sprite.texture = _create_health_pack_texture()
	health_pack.add_child(sprite)
	
	# Add collision for detection
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(20, 20)
	collision.shape = shape
	health_pack.add_child(collision)
	
	# Connect collection signal with the health pack as a parameter
	health_pack.body_entered.connect(_on_health_pack_collected.bind(health_pack))
	
	return health_pack

# Create a health pack texture (green with white cross)
func _create_health_pack_texture() -> ImageTexture:
	var image = Image.create(20, 20, false, Image.FORMAT_RGB8)
	image.fill(Color.GREEN)
	
	# Draw a simple cross
	for x in range(8, 12):
		for y in range(20):
			image.set_pixel(x, y, Color.WHITE)
	for x in range(20):
		for y in range(8, 12):
			image.set_pixel(x, y, Color.WHITE)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture

# Handle health pack collection
func _on_health_pack_collected(body, health_pack):
	if body == player and health_pack in spawned_features:
		print("Health pack collected! Player healed.")
		spawned_features.erase(health_pack)
		health_pack.queue_free()

# Override room setup for battle-specific configuration
func _setup_room():
	print("Setting up BattleRoom...")
	# Could add battle-specific room modifications here
	# For example: dimmer lighting, warning signs, etc.