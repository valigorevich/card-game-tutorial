extends CardState

func enter() -> void:
	card_ui.drop_point_detector.monitoring = true
	
func on_input(event: InputEvent) -> void:
	#If we move the mouse we transition to moving state
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
