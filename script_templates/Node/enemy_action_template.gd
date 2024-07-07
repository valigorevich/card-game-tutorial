#meta-name: Enemy Action
#meta-description: An action which can be performed by an enemy during its turn
extends EnemyAction


func perform_action() -> void:
	if not enemy or not target:
		return
	
	#Move towards a player on action (e.g. atack)
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	
	#Action sound
	SFXPlayer.play(sound)
	
	#Signal when action finished
	Events.enemy_action_completed.emit(enemy)


# Dynamic text for intent if it uses modifiers.
# If an enemy has dynamic text you can override the base behaviour here.
# e.g. for atack actions, the Player's DMG_TAKEN modifier modifies the resulting damage number
# If we don't need to override, just delete it. Enemy_action class will take care of basic behaviour.
func update_intent_text() -> void:
	#Grab a player to see his modifiers
	var player := target as Player
	
	if not player:
		return
	
	#Calculate modified damage. "6" should be replaced with actual intent damage value
	var modified_damage := player.modifier_handler.get_modified_value(6, Modifier.Type.DMG_TAKEN)
	#Intent base text must have %s in its text field. Current_text is displayed in intent_ui
	intent.current_text = intent.base_text % modified_damage
