class_name EnemyWave
extends Resource

@export var waves: Array[EnemySpawner] = []


func select_wave() -> EnemySpawner:
	return waves.pick_random()
