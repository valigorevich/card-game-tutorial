class_name Relic
extends Resource

enum Type {START_OF_TURN, END_OF_TURN, START_OF_COMBAT, END_OF_COMBAT, EVENT_BASED}
enum CharacterType {ALL, ASSASSIN, WARRIOR, WIZARD} #Probably not the best place to set this. But good enough.

@export var relic_name: String
@export var id: String
@export var type: Type
@export var character_type: CharacterType
@export var starter_relic: bool = false
@export var icon: Texture
@export_multiline var tooltip: String


func initialize_relic(_owner: RelicUI) -> void:
	pass


func activate_relic(_owner: RelicUI) -> void:
	pass

# This method should be implemented by event-based relics
# which connect to EventBus to make sure that they are
# disconnected when relic gets removed
func deactivate_relic(_owner: RelicUI) -> void:
	pass


# Use for dynamic UI numbers
func get_tooltip() -> String:
	return tooltip


#Relic provides info if it can be appearen as reward (in shop or battle_reward)
func can_appear_as_reward(character: CharacterStats) -> bool:
	# Starter relics can't be a reward
	if starter_relic:
		return false
	
	# For all character relics it always valid
	if character_type == CharacterType.ALL:
		return true
	
	#Check for specific character by name (sic!). Must be ensired that enum names are equal character names
	var relic_char_name: String = CharacterType.keys()[character_type].to_lower()
	var char_name := character.character_name.to_lower()
	
	return relic_char_name == char_name
