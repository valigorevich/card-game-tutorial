extends CardState

#A threshold for y-mouse position when we cancel the movement of aiming
const MOUSE_Y_SNAPBACK_THRESHOLD := 138

func enter() -> void:
	card_ui.targets.clear()
	
	#Calculate offset of a card and animate movement of card to a position
	var offset := Vector2(card_ui.parent.size.x / 2, -card_ui.parent.size.y / 2)
	offset.x -= card_ui.size.x / 2
	card_ui.animate_to_position(card_ui.parent.global_position + offset, 0.2)
	card_ui.drop_point_detector.monitoring = false
	Events.card_aim_started.emit(card_ui) #emit a signal from global events that we started aiming
	

func exit() -> void:
	Events.card_aim_ended.emit(card_ui)

func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion #true if we move a mouse
	var mouse_at_bottom := card_ui.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_THRESHOLD #true if we below snapback point
	
	#return to the base state if we moved below threshold or canceled
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
	#or transite to released state
	elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
