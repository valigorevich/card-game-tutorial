#meta-name: Card Logic
#meta-description: What happens when a card is played
extends Card

@export var optional_sound: AudioStream

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	print("My awesome card has been played!")
	print("Targets: %s" % targets)


#This is used for default tooltips, like card tooltip in card_pive_view
func get_default_tooltip() -> String:
	return tooltip_text


# Virual method for getting dynamic card tooltips based on modifiers.
# Overrides in specific cards scripts
# Used for tooltips when selected a card to play to take modifiers in considetation.
func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text
