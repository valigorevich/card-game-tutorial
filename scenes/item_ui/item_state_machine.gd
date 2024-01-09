class_name ItemStateMachine
extends Node

@export var initial_state: ItemState

var current_state: ItemState

var states = {}


func init(item: ItemUI) -> void:
	for child in get_children():
		if child is ItemState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)  #connect signal from state to transition function
			child.item_ui = item

	if initial_state:
		initial_state.enter()
		current_state = initial_state


func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func _on_transition_requested(from: ItemState, to: ItemState.State) -> void:
	#check if from-state is the same as current (in case something happened)
	if from != current_state:
		return

	var new_state: ItemState = states[to]  #Take to-state from dictionary of states
	#If we try to transition to nonexisting state we return
	if not new_state:
		return

	#If state exists, we first exit from current state
	if current_state:
		current_state.exit()

	#than we enter a new state and set new state as current
	new_state.enter()
	current_state = new_state
