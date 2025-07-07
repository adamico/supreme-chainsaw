class_name SacrificeShrine extends StaticBody2D

var player: Player

var cards: Array = []


func interact() -> void:
	if not player:
		return
	EventBus.player_activated_sacrifice_shrine.emit(player, self)
