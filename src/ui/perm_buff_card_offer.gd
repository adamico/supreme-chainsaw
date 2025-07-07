class_name PermBuffCardOffer extends CardOffer

var memory_shard_cost: int = 1
var max_hp_increase: int = 5

@onready var memory_text: RichTextLabel = %MemoryText
@onready var perm_buff_accept_button: Button = %PermBuffAcceptButton

func _ready() -> void:
	_add_card_details()


func _process(_delta: float) -> void:
	player = get_tree().get_first_node_in_group("players")
	if not player:
		print("Player node is not set.")
		return

	perm_buff_accept_button.disabled = player.memory_shards < memory_shard_cost


func _add_card_details() -> void:
	card_type_label.bbcode_text = "🔗 Permanent Buff"
	sacrifice_icon.bbcode_text = "🧩"
	sacrifice_text.bbcode_text = "[color=lime]" + str(memory_shard_cost) + " Memory Shard[/color]"
	offer_icon.bbcode_text = "❤️‍🩹"
	offer_text.bbcode_text = "[color=red]+" + str(max_hp_increase) + " MAX HP[/color]"
	memory_text.bbcode_text = "[font_size=12]but lose a [color=lime]memory[/color][/font_size]"
	perm_buff_accept_button.pressed.connect(_on_accept_pressed)


func _on_accept_pressed() -> void:
	player.memory_shards -= memory_shard_cost
	player.max_health += max_hp_increase
	print("Player memory shards after accepting permanent buff: ", player.memory_shards)
	print("Player max health after accepting permanent buff: ", player.max_health)
	print("Permanent buff card offer accepted")
	
	super._on_accept_pressed()