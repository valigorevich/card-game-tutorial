extends ItemState


func enter():
	item_ui.panel.set("theme_override_styles/panel", item_ui.DRAG_STYLEBOX)


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		transition_requested.emit(self, ItemState.State.BASE)
