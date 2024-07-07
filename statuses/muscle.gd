class_name MuscleStatus
extends Status

@export var status_id: String = "muscle"

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	#target (player or enemy) may have no modifier_handler attached so we need to assert it
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	
	#target (player or enemy) may have no damage_dealt_modifier attached so we need to assert it
	assert(dmg_dealt_modifier, "No DMG_DEALT modifier on %s" % target)
	#If it is, we can grab a modifier for muscle
	var muscle_modifier_value := dmg_dealt_modifier.get_value(status_id)
	
	#if there are no, we create one by calling static method in ModifierValue class
	if not muscle_modifier_value:
		muscle_modifier_value = ModifierValue.create_new_modifier(status_id, ModifierValue.Type.ADDITIVE)
	
	#Set modifier stats according to muscle stacks
	muscle_modifier_value.additive = stacks
	dmg_dealt_modifier.add_new_value(muscle_modifier_value)
