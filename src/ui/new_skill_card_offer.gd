class_name NewSkillCardOffer extends CardOffer

var skill_name: String = "Dash Ability"
var experience_cost: int = 50

@onready var new_skill_accept_button: Button = %NewSkillAcceptButton


func _ready() -> void:
	_add_card_details()


func _process(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("players")
	if not player:
		print("Player node is not set.")
		return

	new_skill_accept_button.disabled = player.experience < experience_cost


func _add_card_details() -> void:
	card_type_label.bbcode_text = "🔮 New Skill"
	sacrifice_icon.bbcode_text = "🧠"
	sacrifice_text.bbcode_text = "[color=" + Constants.EXPERIENCE_COLOR + "]-" + str(experience_cost) + " XP[/color]"
	offer_icon.bbcode_text = "🏃"
	offer_text.bbcode_text = "[color=" + Constants.SKILL_COLOR + "]" + skill_name + "[/color]"
	new_skill_accept_button.pressed.connect(_on_accept_pressed)


func _on_accept_pressed() -> void:
	player.experience -= experience_cost
	print("Player experience after accepting new skill: ", player.experience)
	print("New skill acquired: ", skill_name)
	print("New Skill card offer accepted")

	super._on_accept_pressed()
