class_name EnemyHandler
extends Node2D

@onready var enemy = preload("res://scenes/enemy/enemy.tscn")

func _ready() -> void:
	Events.enemy_action_completed.connect(_on_enemy_action_completed)
	
#Spawn new enemy on scene
func spawn_enemy(enemy_stats: EnemyStats, position: Vector2) -> void:
	var new_enemy = enemy.instantiate()
	new_enemy.stats = enemy_stats
	new_enemy.global_position = position
	add_child(new_enemy)

#Update enemy actions
func reset_enemy_actions() -> void:
	var enemy: Enemy
	for child in get_children():
		enemy = child as Enemy
		enemy.current_action = null
		enemy.update_action()


#Base enemy turn management
func start_turn() -> void:
	#Check if we have enemies
	if get_child_count() == 0:
		return
	
	var first_enemy: Enemy = get_child(0) as Enemy
	first_enemy.do_turn()
	
func _on_enemy_action_completed(enemy: Enemy) -> void:
	if enemy.get_index() == get_child_count() - 1:
		Events.enemy_turn_ended.emit()
		return
	
	#Pick next enemy and do it's turn
	var next_enemy: Enemy = get_child(enemy.get_index() + 1) as Enemy
	next_enemy.do_turn()
