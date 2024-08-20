# Meta-name: Relic
extends Relic

@export var block := 3


func activate_relic(owner: RelicUI) -> void:
	owner.flash()
	var player := owner.get_tree().get_nodes_in_group("player") # To return array for block effect
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	block_effect.execute(player)
