# SacrificeRoom - A room where players can make sacrifices for power
class_name SacrificeRoom extends Room


func _ready() -> void:
	room_type = RoomType.SACRIFICE
	super._ready()


func _spawn_room_features() -> void:
	_spawn_sacrifice_message()
	

func _spawn_sacrifice_message() -> void:
	var sacrifice_message = Label.new()
	sacrifice_message.text = "Everything has a price! Make your choice!"
	sacrifice_message.position = Vector2(160, 8)
	add_child(sacrifice_message)