class_name ModifierValue
extends Node

enum Type {ADDITIVE, MULTIPLICATIVE}

@export var type: Type
@export var multiplier_add: float
@export var additive: int
@export var source: String


#Build-in static function that can be called by referencing to this class to avoid code duplication
static func create_new_modifier(modifier_source: String, modifier_type: Type) -> ModifierValue:
	var new_modifier := new()
	new_modifier.source = modifier_source
	new_modifier.type = modifier_type
	
	return new_modifier
