extends CardState


func enter() -> void:
	card_ui.panel.set("theme_override_styles/panel", card_ui.DRAG_STYLEBOX)


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
