class_name ScenarioHandler
extends Node

@export var enemy_handler: EnemyHandler

var positions: Array[Marker2D]

func _ready() -> void:
	for child in get_children():
		positions.append(child)

#we pass a scenario to pick proper stats to spawn
func spawn_wave(scenario: BattleScenario, level: int) -> void:
	if not scenario:
		return
	
	#Check if wave level exeedes number of waves
	if level > scenario.enemy_spawner.size():
		#Emit signal that we finished the run to handle win condition
		Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)
		return
	
	var new_enemy_wave := scenario.enemy_spawner[level - 1] as EnemyWave
	var new_enemy_spawner := new_enemy_wave.select_wave() as EnemySpawner
	var enemy_index := 0
	for enemy in new_enemy_spawner.enemies:
		#Check if we have more enemies than markers on level
		if enemy_index > positions.size():
			print("Can't spawn enemy. There is no marker for spawn position")
			return
		
		var position_marker := positions[enemy_index] as Marker2D
		enemy_handler.spawn_enemy(enemy, position_marker.global_position)
		enemy_index += 1
