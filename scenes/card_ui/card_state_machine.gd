class_name CardStateMachine
extends Node

#Defining initial state (the base state)
@export var initial_state: CardState

#Storing current state
var current_state: CardState

#Storing all available states of a card in dictionary
var states := {}

#Init functions, called from card ui. 
func init(card: CardUI) -> void:
	for child in get_children():
		if child is CardState:
			states[child.state] = child #Add to dictionary of states
			child.transition_requested.connect(_on_transition_requested) #connect signal from state to transition function
			child.card_ui = card #pass card ui reference to state to target them
	
	if initial_state:
		initial_state.enter() #if we have initial state we enter it
		current_state = initial_state #set current state as initial state

#Pass input events to current states
func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)

func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)
		
#Pass mouse events to current states
func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()

func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()

#States transition function. Requested from states via signal that we connected during init function
func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	#check if from-state is the same as current (in case something happened)
	if from != current_state:
		return
	
	var new_state: CardState = states[to] #Take to-state from dictionary of states
	#If we try to transition to nonexisting state we return
	if not new_state:
		return
		
	#If state exists, we first exit from current state
	if current_state:
		current_state.exit()
	
	#than we enter a new state and set new state as current
	new_state.enter()
	current_state = new_state
