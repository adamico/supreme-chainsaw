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
	sacrifice_text.bbcode_text = "[color=red]-" + str(health_cost) + " HP[/color]"
	offer_icon.bbcode_text = "⚔️"
	offer_text.bbcode_text = "[color=green]+" + str(damage_bonus) + " DMG[/color]"
	duration_text.bbcode_text = "[font_size=12]for " + str(duration) + " battle rooms[/font_size]"
	temp_buff_accept_button.pressed.connect(_on_accept_pressed)


func _on_accept_pressed() -> void:
	player.health -= health_cost
	player.damage += damage_bonus
	print("Player health after accepting temp buff: ", player.health)
	print("Player damage after accepting temp buff: ", player.damage)
	print("Temporary buff card offer accepted")
	super._on_accept_pressed()