class_name ItemState
extends Node

enum State { BASE, SELECTED }

#export var to assign states in editor when crating new states
@export var state: State

var item_ui: ItemUI


signal transition_requested(from: ItemState, to: ItemState)
#Call back functions for mouse entering and exiting. Will be redefined inside states
func on_mouse_entered() -> void:
	pass


func on_mouse_exited() -> void:
	pass


#Function for entering a state. Will be redefined inside states
func enter() -> void:
	pass


#Function for exiting the state. Will be redefined inside states
func exit() -> void:
	pass

func on_input(_event: InputEvent) -> void:
	pass

func on_gui_input(_event: InputEvent) -> void:
	pass