class_name EnemyHandler
extends Node2D

var acting_enemies: Array[Enemy] = [] #array for tracking all enemies each turn


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)
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
		new_enemy_child.status_handler.statuses_applied.connect(_on_enemy_statuses_applied.bind(new_enemy_child))
	
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
	
	#populate acting enamies array with all scene enemies
	acting_enemies.clear()
	for enemy: Enemy in get_children():
		acting_enemies.append(enemy)
	
	_start_next_enemy_turn()


func _start_next_enemy_turn() -> void:
	#check if we have enemies
	if acting_enemies.is_empty():
		Events.enemy_turn_ended.emit()
		return
	
	#Grab first enemy in acting enemies and apply start turn statuses
	acting_enemies[0].status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
	#When all statuses applied, the signal will be emited with that enemy and type of statuses
	#So we proceed ti _on_enemy_statuses_applied function


func _on_enemy_statuses_applied(type: Status.Type, enemy: Enemy) -> void:
	match type:
		#If it was a start turn statuses, we allow enemy to do it's turn
		Status.Type.START_OF_TURN:
			enemy.do_turn()
		#If it;s end-turn statuses, we erase enemy from acting enemies and start next enemy turn
		Status.Type.END_OF_TURN:
			acting_enemies.erase(enemy)
			_start_next_enemy_turn()


func _on_enemy_died(enemy: Enemy) -> void:
	#At first we must check if it is an enemy turn
	var is_enemy_turn := acting_enemies.size() > 0
	#then we delete enemy from acting_enemies
	acting_enemies.erase(enemy)
	
	#proceed to next enemy	
	if is_enemy_turn:
		_start_next_enemy_turn()


func _on_enemy_action_completed(enemy: Enemy) -> void:
	#when all actions of enemy are completed, we call end-of-turn statuses
	enemy.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
	#When all stuses have been applie, _on_enemy_statuses_applied will be called
