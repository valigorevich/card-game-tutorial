class_name StatusHandler
extends GridContainer

signal statuses_applied(type: Status.Type) #Signal when all statuses of given type are applied

const STATUS_APPLY_INTERVAL = 0.25
const STATUS_UI = preload("res://scenes/status_handler/status_ui.tscn")

#We want to know, whoever we apply statuses to
@export var status_owner: Node2D

#Main function to apply statuses when needed. Used by enemy_handler and player_handler to orchestrate the logic for the battle
func apply_statuses_by_type(type: Status.Type) -> void:
	#Ignore event-based statuses becasue they apply depending on their corresponding events from event bus
	if type == Status.Type.EVENT_BASED:
		return
	
	#Get all statuses filtered by type (for start-turn and end-turn statuses, because this is most of our statuses)
	var status_queue: Array[Status] = _get_all_statuses().filter(
		func(status: Status):
			return status.type == type
	)
	
	#if don't have anything to apply, we return and emit a signal that we passed that stage
	if status_queue.is_empty():
		statuses_applied.emit(type)
		return
	
	#Apply statuses one by one with a give interval
	var tween := create_tween()
	for status: Status in status_queue:
		tween.tween_callback(status.apply_status.bind(status_owner))
		tween.tween_interval(STATUS_APPLY_INTERVAL)
	
	tween.finished.connect(func(): statuses_applied.emit(type))

#Here we add new status, but we need to check a lot of stuff depending on current statuses
func add_status(status: Status) -> void:
	#Check if status is stackable
	var stackable := status.stack_type != Status.StackType.NONE
	
	#If it is new status, we add it
	if not _has_status(status.id):
		var new_status_ui := STATUS_UI.instantiate() as StatusUI
		add_child(new_status_ui)
		new_status_ui.status = status
		new_status_ui.status.status_applied.connect(_on_status_applied)
		new_status_ui.status.initialize_status(status_owner)
		return
	
	#If it is unique status and we already have it, we can return.
	if not status.can_expire and not stackable:
		return
	
	#If it's a duration-stackable, we expand it's duration
	if status.can_expire and status.stack_type == Status.StackType.DURATION:
		_get_status(status.id).duration += status.duration
		return
	
	#If it is stackable, we add stacks:
	if status.stack_type == Status.StackType.INTENSIFY:
		_get_status(status.id).stacks += status.stacks
		return
	#If we have both stackable and duration-stackable status, we need to expand our if statements to check for that type also
	

#Iterate through children to find a status by id
func _has_status(id: String) -> bool:
	for status_ui: StatusUI in get_children():
		if status_ui.status.id == id:
			return true
	
	return false

#Iterate though children to return status by id. Probably can merge with func above to have less code.
func _get_status(id: String) -> Status:
	for status_ui: StatusUI in get_children():
		if status_ui.status.id == id:
			return status_ui.status
	
	return null


func _get_all_statuses() -> Array[Status]:
	var statuses: Array[Status] = []
	for status_ui: StatusUI in get_children():
		statuses.append(status_ui.status)
	
	return statuses


func _on_status_applied(status: Status) -> void:
	if status.can_expire:
		status.duration -= 1


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Events.status_tooltip_requested.emit(_get_all_statuses())
