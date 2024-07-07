class_name CardUI
extends Control

#A signal to reparent back to hbox container as dragged card will be out of hbox container
signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = _set_card
@export var character_stats: CharacterStats : set = _set_character_stats
@export var player_modifiers: ModifierHandler

@onready var card_visuals: CardVisuals = $CardVisuals
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()

var parent: Control
var tween: Tween
var playable := true : set = _set_playable
var disabled := false

func _ready() -> void:
	#Connect signals from event bus
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_drag_ended.connect(_on_card_drag_or_aiming_ended)
	#Initiate the state machine
	card_state_machine.init(self)


func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)


func play() -> void:
	if not card:
		return

	card.play(targets, character_stats, player_modifiers)
	queue_free()


#Requesting tooltip with modifiers
func request_tooltip() -> void:
	var enemy_modifiers := _get_active_enemy_modifiers()
	var update_tooltip := card.get_updated_tooltip(player_modifiers, enemy_modifiers)
	Events.card_tooltip_requested.emit(card.icon, update_tooltip)

# Utility function to get enemy modifiers handler to get its modifiers
func _get_active_enemy_modifiers() -> ModifierHandler:
	#If not targets, or many targets, or target is not an enemy - we pass
	if targets.is_empty() or targets.size() > 1 or not targets[0] is Enemy:
		return null
	
	return targets[0].modifier_handler


func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	card_visuals.card = card


func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		card_visuals.cost.add_theme_color_override("font_color", Color.RED)
		card_visuals.icon.modulate = Color(1, 1, 1, 0.5)
	else:
		card_visuals.cost.remove_theme_color_override("font_color")
		card_visuals.icon.modulate = Color(1, 1, 1, 1)


func _set_character_stats(value: CharacterStats) -> void:
	character_stats = value
	character_stats.stats_changed.connect(_on_character_stats_changed)


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)


func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	
	disabled = true


func _on_card_drag_or_aiming_ended(_card: CardUI) -> void:
	disabled = false
	playable = character_stats.can_play_card(card)
	
	
func _on_character_stats_changed() -> void:
	playable = character_stats.can_play_card(card)
