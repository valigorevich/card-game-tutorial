class_name Card
extends Resource

#Define enum for types of cards and types os targets
enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
@export var sound: AudioStream


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY

#Select a correct amount of targets as a array of nodes. Based on the enum we set in a card type and target.
#The result is a valid array of nodes to pass to the effect execute function.
func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []


func play(targets: Array[Node], character_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	character_stats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))
		

#Virtual method for effects application based on a specific card
func apply_effects(_targets: Array[Node]) -> void:
	pass
