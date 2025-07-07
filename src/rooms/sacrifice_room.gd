# SacrificeRoom - A room where players can make sacrifices for power
class_name SacrificeRoom extends Room

const SACRIFICE_SHRINE_SCENE: PackedScene = preload("res://src/rooms/features/sacrifice_shrine.tscn")

func _ready() -> void:
	room_type = RoomType.SACRIFICE
	EventBus.player_entered_sacrifice_room.emit()
	super._ready()


func _spawn_room_features() -> void:
	_spawn_sacrifice_shrine()
	

func _spawn_sacrifice_shrine() -> void:
	print("Spawning sacrifice shrine...")
	var spawn_pos = _get_random_spawn_point()
	spawn_feature(FeatureType.SACRIFICE_SHRINE, spawn_pos)


func _create_feature(feature_type: FeatureType) -> Node2D:
	match feature_type:
		FeatureType.SACRIFICE_SHRINE:
			return _create_sacrifice_shrine()
		_:
			# Fall back to base class for common features
			return super._create_feature(feature_type)


func _create_sacrifice_shrine() -> Node2D:
	var shrine = SACRIFICE_SHRINE_SCENE.instantiate()
	shrine.name = "SacrificeShrine"

	var sprite = Sprite2D.new()
	sprite.texture = _create_colored_texture(Vector2(64, 32), Color.YELLOW)
	shrine.add_child(sprite)

	shrine.player = player

	return shrine
