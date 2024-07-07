class_name Modifier
extends Node

enum Type {DMG_DEALT, DMG_TAKEN, CARD_COST, SHOP_COST, NO_MODIFIER}

@export var type: Type


func get_value(source: String) -> ModifierValue:
	for value: ModifierValue in get_children():
		if value.source == source:
			return value
	
	return null


#Called to add new modifier values, called from a specific modifier. 
#A ModifierValue itself is created in other places where it supposed to be created (status or others) but added here.
func add_new_value(value: ModifierValue) -> void:
	#if we don't have it, we add it
	var modifier_value := get_value(value.source)
	if not modifier_value:
		add_child(value)
	#if we have that modifier value, we override
	else:
		modifier_value.multiplier_add = value.multiplier_add
		modifier_value.additive = value.additive


func remove_value(source: String) -> void:
	for value: ModifierValue in get_children():
		if value.source == source:
			value.queue_free()


func clear_values() -> void:
	for value: ModifierValue in get_children():
		value.queue_free()


#Main calculation function. result = (base+adds)*mult, rounded down.
func get_modified_value(base: int) -> int:
	var base_result: int = base
	var multiplier_result: float = 1.0
	
	#Apply additive modifiers first
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.ADDITIVE:
			base_result += value.additive
	
		#Apply multiplicative modifiers
		if value.type == ModifierValue.Type.MULTIPLICATIVE:
			multiplier_result += value.multiplier_add
	
	return floori(base_result * multiplier_result)
