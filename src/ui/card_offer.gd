class_name CardOffer extends Panel

var player: Node2D

@onready var card_type_label: RichTextLabel = %CardTypeLabel
@onready var sacrifice_icon: RichTextLabel = %SacrificeIcon
@onready var sacrifice_text: RichTextLabel = %SacrificeText
@onready var offer_icon: RichTextLabel = %OfferIcon
@onready var offer_text: RichTextLabel = %OfferText


# virtual method to apply the effects of the card offer
# this should be overridden in subclasses
func _on_accept_pressed() -> void:
	EventBus.card_offer_accepted.emit()
	var shrine: Node2D = get_tree().get_first_node_in_group("sacrifice_shrines")
	if shrine:
		shrine.call_deferred(&"queue_free")
		print("Card offer accepted, shrine queued for free.")