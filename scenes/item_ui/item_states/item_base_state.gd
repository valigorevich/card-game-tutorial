extends ItemState


func enter():
	if not item_ui.is_node_ready():
		await item_ui.ready

	item_ui.panel.set("theme_override_styles/panel", item_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()


func on_mouse_entered() -> void:

	item_ui.panel.set("theme_override_styles/panel", item_ui.HOVER_STYLEBOX)
	Events.tooltip_requested.emit(item_ui.item.icon, item_ui.item.tooltip_text)


func on_mouse_exited() -> void:

	item_ui.panel.set("theme_override_styles/panel", item_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()


func on_gui_input(event: InputEvent) -> void:
	if item_ui.selectable and event.is_action_pressed("left_mouse"):
		transition_requested.emit(self, ItemState.State.SELECTED)
		Events.item_selected.emit(item_ui)
		print(item_ui)

	if not item_ui.playable or item_ui.disabled:
		return
