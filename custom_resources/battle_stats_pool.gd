class_name BattleStatsPool
extends Resource

@export var pool: Array[BattleStats]

var total_weight_by_tier := [0.0, 0.0, 0.0]

#Main function to get a random battle based on tier
func get_random_battle_for_tier(tier: int) -> BattleStats:
	var battles := _get_all_battles_for_tier(tier)
	var roll = randf_range(0.0, total_weight_by_tier[tier])
	
	for battle: BattleStats in battles:
		if battle.accumulated_weight > roll:
			return battle
			
	return null


#Pick tier and filter all battlestats that matches the tier.
func _get_all_battles_for_tier(tier: int) -> Array[BattleStats]:
	return pool.filter(
		func(battle: BattleStats):
			return battle.battle_tier == tier
	)


#Initial calculation for chances for all battles. Done once at the start of map generation.
func setup() -> void:
	for i in total_weight_by_tier.size():
		_setup_weight_for_tier(i)


#Setup weights function to calculate weights per tier
func _setup_weight_for_tier(tier: int) -> void:
	var battles := _get_all_battles_for_tier(tier)
	total_weight_by_tier[tier] = 0.0
	
	for battle: BattleStats in battles:
		total_weight_by_tier[tier] += battle.weight
		battle.accumulated_weight = total_weight_by_tier[tier]
