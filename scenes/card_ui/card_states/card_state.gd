class_name CardState
extends Node

#Defining all the states the card can be in as an enum
enum State {BASE, CLICKED, DRAGGING, AIMING, RELEASED}

#Signal with transition parameters: from and to
signal transition_requested(from: CardState, to: CardState)

#export var to assign states in editor when crating new states
@export var state: State

#reference to the ui stuff for moving, changing color and labes and so on
var card_ui: CardUI

#Function for entering a state. Will be redefined inside states
func enter() -> void:
	pass

#Function for exiting the state. Will be redefined inside states
func exit() -> void:
	pass

#Functions for input events. Will be redefined inside states
func on_input(_event: InputEvent) -> void:
	pass

func on_gui_input(_event: InputEvent) -> void:
	pass

#Call back functions for mouse entering and exiting. Will be redefined inside states
func on_mouse_entered() -> void:
	pass

func on_mouse_exited() -> void:
	pass
