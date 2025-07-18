class_name TempBuffCardOffer extends CardOffer

var health_cost: int = 20
var damage_bonus: int = 5
var duration: int = 3  # in battle rooms

@onready var duration_text: RichTextLabel = %DurationText
@onready var temp_buff_accept_button: Button = %TempBuffAcceptButton


func _ready() -> void:
	_add_card_details()


func _process(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("players")
	if not player:
		print("Player node is not set.")
		return

	temp_buff_accept_button.disabled = player.health <= health_cost


func _add_card_details() -> void:
	card_type_label.bbcode_text = "🕰️ Temporary Buff"
	sacrifice_icon.bbcode_text = "💔"
	sacrifice_text.bbcode_text = "[color=" + Constants.HEALTH_COLOR + "]-" + str(health_cost) + " HP[/color]"
	offer_icon.bbcode_text = "⚔️"
	offer_text.bbcode_text = "+" + str(damage_bonus) + " DMG"
	duration_text.bbcode_text = "for " + str(duration) + " battle rooms"
	temp_buff_accept_button.pressed.connect(_on_accept_pressed)


func _on_accept_pressed() -> void:
	player.health -= health_cost
	player.attack_damage += damage_bonus
	print("Player health after accepting temp buff: ", player.health)
	print("Player attack damage after accepting temp buff: ", player.attack_damage)
	print("Temporary buff card offer accepted")
	super._on_accept_pressed()
