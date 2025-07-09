class_name SacrificeShrine extends Area2D

var player: Player

var cards: Array = []


func interact() -> void:
	if not player:
		return
	EventBus.player_activated_sacrifice_shrine.emit(player, self)
