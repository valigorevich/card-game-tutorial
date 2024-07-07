class_name Card
extends Resource

#Define enum for types of cards and types of targets
enum Type {ATTACK, SKILL, POWER}
enum Rarity {COMMON, UNCOMMON, RARE}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}
enum PlayFolowup {DISCARD, EXHAUST, VANISH}

const RARITY_COLORS := {
	Card.Rarity.COMMON: Color.GRAY,
	Card.Rarity.UNCOMMON: Color.CORNFLOWER_BLUE,
	Card.Rarity.RARE: Color.GOLD,
}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var rarity: Rarity
@export var target: Target
@export var cost: int
@export var play_folowup: PlayFolowup

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


func play(targets: Array[Node], character_stats: CharacterStats, modifiers: ModifierHandler) -> void:
	Events.card_played.emit(self)
	character_stats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets, modifiers)
	else:
		apply_effects(_get_targets(targets), modifiers)
		

#Virtual method for effects application based on a specific card
func apply_effects(_targets: Array[Node], modifiers: ModifierHandler) -> void:
	pass


#This is used for default tooltips, like card tooltip in card_pive_view
func get_default_tooltip() -> String:
	return tooltip_text


# Virual method for getting dynamic card tooltips based on modifiers.
# Overrides in specific cards scripts
# Used for tooltips when selected a card to play to take modifiers in considetation.
func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text
