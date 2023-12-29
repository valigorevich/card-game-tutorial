class_name EnemySpawnerPicker
extends Node

@onready var total_weight := 0.0


func _ready() -> void:
	setup_chances()
	

func get_enemy_spawner() -> EnemySpawner:
	var enemy_spawner: EnemySpawner
	var roll := randf_range(0.0, total_weight)
	
	for child in get_children():
		enemy_spawner = child as EnemySpawner
		if not enemy_spawner:
			continue
		
		if enemy_spawner.accumulated_weight > roll:
			return enemy_spawner
			
	return null


func setup_chances() -> void:
	var enemy_spawner: EnemySpawner
	
	for child in get_children():
		enemy_spawner = child as EnemySpawner
		if not enemy_spawner:
			continue
		
		total_weight += enemy_spawner.chance_weight
		enemy_spawner.accumulated_weight = total_weight
