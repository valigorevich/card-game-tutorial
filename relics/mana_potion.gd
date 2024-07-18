# Meta-name: Relic
extends Relic

@export var mana_amount := 1


func activate_relic(owner: RelicUI) -> void:
	Events.player_hand_drawn.connect(_add_mana.bind(owner), CONNECT_ONE_SHOT)
	# More elegant solution will be creating a separate signal in Event bus for this specific case
	# e.g. player_start_combat_relic_activation, which is emited right after all player stats reset


func _add_mana(owner: RelicUI) -> void:
	owner.flash()
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	if player:
		player.stats.mana += 1
