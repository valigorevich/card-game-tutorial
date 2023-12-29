class_name EnemySpawner
extends Node

@export var enemies: Array[EnemyStats] = []
@export_range(0.0, 100.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

#This will spawn enemies
func spawn() -> void:
	pass
