class_name ManaUI
extends Panel

@export var character_stats: CharacterStats : set = _set_char_stats

@onready var mana_label: Label = $ManaLabel


func _set_char_stats(value: CharacterStats) -> void:
	character_stats = value
	
	if not character_stats.stats_changed.is_connected(_on_stats_changed):
		character_stats.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()


func _on_stats_changed() -> void:
	mana_label.text = "%s/%s" % [character_stats.mana, character_stats.max_mana]
