extends CardState

var mouse_over_card := false

func enter() -> void:
	#wait for card to be ready
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	#This fixes and issue when state changes during tween animation
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	card_ui.reparent_requested.emit(card_ui) #return to hbox container
	card_ui.pivot_offset = Vector2.ZERO #reset pivot changed from dragging
	Events.tooltip_hide_requested.emit()

func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	#Transition to clicked state
	if event.is_action_pressed("left_mouse") and mouse_over_card:
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	
	mouse_over_card = true
	
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	card_ui.request_tooltip()

func on_mouse_exited() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	
	mouse_over_card = false
	
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()
