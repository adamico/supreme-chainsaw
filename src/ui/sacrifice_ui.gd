class_name SacrificeUI extends Control

var cards: Array[Node]

@onready var cancel_button: Button = %CancelButton


func _ready() -> void:
	print("SacrificeUI ready")
	cancel_button.pressed.connect(_on_cancel_pressed)
	cards = get_tree().get_nodes_in_group("cards")

	if cards.size() == 0:
		return

	print("SacrificeUI ready, found cards: ", cards)


func _on_cancel_pressed() -> void:
	hide()