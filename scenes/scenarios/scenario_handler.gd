class_name ScenarioHandler
extends Node

@export var enemy_handler: EnemyHandler

var positions: Array[Marker2D]

func _ready() -> void:
	for child in get_children():
		positions.append(child)

#we pass a scenario to pick proper stats to spawn
func spawn_wave(scenario: BattleScenario, level: int) -> void:
	if level > scenario.enemy_spawner.size():
		#Emit signal that we finished the run to handle win condition
		return
	
	var new_enemy_wave := scenario.enemy_spawner[level - 1] as EnemyWave
	var new_enemy_spawner := new_enemy_wave.select_wave() as EnemySpawner
	var enemy_index := 0
	for enemy in new_enemy_spawner.enemies:
		var position_marker := positions[enemy_index] as Marker2D
		enemy_handler.spawn_enemy(enemy, position_marker.global_position)
		enemy_index += 1
