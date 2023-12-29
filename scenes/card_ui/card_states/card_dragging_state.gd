extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.25

var minimum_drag_time_elapsed := false

func enter() -> void:
	#at first we need to reparent from hbox
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.DRAG_STYLEBOX)
	Events.card_drag_started.emit(card_ui)
	
	#Specific threshhold timer to address the issue of releasing if quick click-release occurs.
	minimum_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): minimum_drag_time_elapsed = true)

#Transitions functions
func on_input(event: InputEvent) -> void:
	var single_targeted := card_ui.card.is_single_targeted()
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if single_targeted and mouse_motion and card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return #we don't care about other stuff when we changed state
	
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
		
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif confirm and minimum_drag_time_elapsed:
		#set the input as handled so we dont accidentaly pick up new stuff
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)

func exit() -> void:
	Events.card_drag_ended.emit(card_ui)
