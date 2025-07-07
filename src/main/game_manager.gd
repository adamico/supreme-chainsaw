class_name GameManager extends Node2D

const SACRIFICE_UI_SCENE: PackedScene = preload("res://src/ui/sacrifice_ui.tscn")

@onready var sacrifice_shrine_layer: CanvasLayer = %SacrificeShrineLayer

var sacrifice_ui: Control

func _ready() -> void:
	print("GameManager initialized")

	EventBus.card_offer_accepted.connect(_on_card_offer_accepted)
	EventBus.player_activated_sacrifice_shrine.connect(_on_player_activated_sacrifice_shrine)
	EventBus.player_entered_sacrifice_room.connect(_setup_sacrifice_shrine_ui)


func _setup_sacrifice_shrine_ui() -> void:
	sacrifice_ui = SACRIFICE_UI_SCENE.instantiate()
	sacrifice_shrine_layer.call_deferred(&"add_child", sacrifice_ui)
	sacrifice_ui.hide()  # Hide UI initially


func _on_player_activated_sacrifice_shrine(player: Node2D, shrine: Node2D) -> void:
	print("Player ", player.name, " activated sacrifice shrine: ", shrine.name)
	sacrifice_ui.show()  # Show the sacrifice UI


func _on_card_offer_accepted() -> void:
	print("Card offer accepted")
	sacrifice_ui.hide()
	sacrifice_ui.queue_free()  # Free the UI after accepting the offer
