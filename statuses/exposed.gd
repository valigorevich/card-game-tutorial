class_name ExposedStatus
extends Status

const MODIFIER := 0.5

var status_id: String = "exposed"

#We need to create ModofierValues when exposed applied
func initialize_status(target: Node) -> void:
	#target (player or enemy) may have no modifier_handler attached so we need to assert it
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	var dmg_taken_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_TAKEN)
	
	#target (player or enemy) may have no dmg_taken_modifier attached so we need to assert it
	assert(dmg_taken_modifier, "No DMG_TAKEN modifier on %s" % target)
	#If it is, we can grab a modifier for exposed
	var exposed_modifier_value := dmg_taken_modifier.get_value(status_id)
	
	#if there are no, we create one by calling static method in ModifierValue class
	if not exposed_modifier_value:
		exposed_modifier_value = ModifierValue.create_new_modifier(status_id, ModifierValue.Type.MULTIPLICATIVE)
	
	#Set modifier stats according to muscle stacks
	exposed_modifier_value.multiplier_add = MODIFIER
	dmg_taken_modifier.add_new_value(exposed_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmg_taken_modifier))


func _on_status_changed(dmg_taken_modifier: Modifier) -> void:
	if duration <= 0 and dmg_taken_modifier:
		dmg_taken_modifier.remove_value(status_id)


func get_tooltip() -> String:
	return tooltip % duration
