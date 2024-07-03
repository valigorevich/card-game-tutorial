class_name EnemyHandler
extends Node2D


func _ready() -> void:
	Events.enemy_action_completed.connect(_on_enemy_action_completed)

#Get enemies from battle stats resource to put them in scene
func setup_enemies(battle_stats: BattleStats) -> void:
	if not battle_stats:
		return
	
	for enemy: Enemy in get_children():
		enemy.queue_free()
	
	#Get an instance of enemies setup
	var all_new_enemies = battle_stats.enemies.instantiate()
	
	#Get Enemies from that scence, duplicate and place in battle
	for new_enemy: Node2D in all_new_enemies.get_children():
		var new_enemy_child := new_enemy.duplicate() as Enemy
		add_child(new_enemy_child)
	
	#Delete instance of enemies group
	all_new_enemies.queue_free()

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
