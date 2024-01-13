class_name CardUI
extends ControlUiBase

#A signal to reparent back to hbox container as dragged card will be out of hbox container
signal reparent_requested(which_card_ui: CardUI)

@export var card: Card : set = _set_card
@export var character_stats: CharacterStats : set = _set_character_stats

@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()

var tween: Tween
var playable := true : set = _set_playable
var disabled := false
var selectable = false
var preview_mode = false : set = _set_preview_mode

func init(props):
	super(props)

func _ready() -> void:
	#Connect signals from event bus
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_drag_ended.connect(_on_card_drag_or_aiming_ended)
	var props = {
		state_machine = card_state_machine,
		child = self
	}
	self.init(props)


func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)


func play() -> void:
	if not card:
		return

	card.play(targets, character_stats)
	queue_free()

func _set_card(value: Card) -> void:
	super._set_item(value)
	card = item

func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1, 1, 1, 0.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1, 1, 1, 1)


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
	self.playable = character_stats.can_play_card(card)
	
	
func _on_character_stats_changed() -> void:
	self.playable = character_stats.can_play_card(card)

func _set_preview_mode(mode: bool):
	preview_mode = mode
