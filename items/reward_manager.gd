class_name RewardManager
extends Node

@export var wave_rewards: Array[CardPile] = []
var current_wave_level
var player

var current_reward

func _ready():
	var battle = get_parent()

	current_wave_level = battle.current_wave_level
	player = battle.player


func calculate_wave_reward():
	current_reward = wave_rewards[current_wave_level - 1] 
	if not current_reward:
		current_reward = wave_rewards[0]
