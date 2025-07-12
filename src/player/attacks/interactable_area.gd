extends Area2D

var is_interactable:= false


func interact(player):
	if not is_interactable:
		return
	var parent = get_parent()
	var damage = get_parent().damage
	# refund a fraction of the attack cost to the player
	# this is calculated based on the attack's damage and the attack_refund_cost player stat
	# the attack_refund_cost stat can be modified during the gameplay
	# this is used to balance the game
	player.health += damage / player.attack_refund_cost
	# make sure the attack is deleted
	parent.queue_free()
