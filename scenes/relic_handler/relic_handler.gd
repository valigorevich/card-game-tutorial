class_name RelicHandler
extends HBoxContainer

signal relics_activated(type: Relic.Type)

const RELIC_APPLY_INTERVAL := 0.5
const RELIC_UI = preload("res://scenes/relic_handler/relic_ui.tscn")

@onready var relics_control: RelicControl = $RelicsControl
@onready var relics: HBoxContainer = %Relics


func _ready() -> void:
	relics.child_exiting_tree.connect(_on_relics_child_exiting_tree)


func activate_relics_by_type(type: Relic.Type) -> void:
	#Event-based relics act autonomously
	if type == Relic.Type.EVENT_BASED:
		return
	
	#Get all relics filtered by type
	var relic_queue: Array[RelicUI] = _get_all_relic_ui_nodes().filter(
		func(relic_ui: RelicUI):
			return relic_ui.relic.type == type
	)
	
	#If no relics of that type, we emit a signal that we finished and return
	if relic_queue.is_empty():
		relics_activated.emit(type)
		return
	
	#If there are relics, activate them one by one
	var tween := create_tween()
	for relic_ui: RelicUI in relic_queue:
		tween.tween_callback(relic_ui.relic.activate_relic.bind(relic_ui))
		tween.tween_interval(RELIC_APPLY_INTERVAL)
	
	tween.finished.connect(func(): relics_activated.emit(type))


#We use this to save and load game
func add_relics(relics_array: Array[Relic]) -> void:
	for relic: Relic in relics_array:
		add_relic(relic)


func add_relic(relic: Relic) -> void:
	#We can't have two identical relics
	if has_relic(relic.id):
		return
	
	#If it's a new relic, add and initialize it
	var new_relic_ui := RELIC_UI.instantiate() as RelicUI
	relics.add_child(new_relic_ui)
	new_relic_ui.relic = relic
	new_relic_ui.relic.initialize_relic(new_relic_ui)


func has_relic(id: String) -> bool:
	for relic_ui: RelicUI in relics.get_children():
		if relic_ui.relic.id == id and is_instance_valid(relic_ui):
			return true
	
	return false


func get_all_relics() -> Array[Relic]:
	var relic_ui_nodes := _get_all_relic_ui_nodes()
	var relics_array: Array[Relic] = []
	
	for relic_ui: RelicUI in relic_ui_nodes:
		relics_array.append(relic_ui.relic)
	
	return relics_array


func _get_all_relic_ui_nodes() -> Array[RelicUI]:
	var all_relics: Array[RelicUI] = []
	for relic_ui: RelicUI in relics.get_children():
		all_relics.append(relic_ui)
	
	return all_relics


func _on_relics_child_exiting_tree(relic_ui: RelicUI) -> void:
	if not relic_ui:
		return
	
	#in case we delete relic, we need to deactivate it's effect.
	#e.g. shop_discount relic being replaced (sold) in shop should immediately loose its effect
	if relic_ui.relic:
		relic_ui.relic.deactivate_relic(relic_ui)
