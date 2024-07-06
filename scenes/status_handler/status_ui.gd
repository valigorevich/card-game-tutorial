class_name StatusUI
extends Control

@export var status: Status : set = set_status

@onready var icon: TextureRect = $Icon
@onready var duration: Label = $Duration
@onready var stacks: Label = $Stacks


func set_status(new_status: Status) -> void:
	if not is_node_ready():
		await  ready
	
	status = new_status
	icon.texture = status.icon
	duration.visible = status.stack_type == Status.StackType.DURATION
	stacks.visible = status.stack_type == Status.StackType.INTENSIFY
	custom_minimum_size = icon.size
	
	#Modify UI size by size of text label
	if duration.visible:
		custom_minimum_size = duration.size + duration.position
	elif stacks.visible:
		custom_minimum_size = stacks.size + stacks.position
	
	if not status.status_changed.is_connected(_on_status_changed):
		status.status_changed.connect(_on_status_changed)
	
	_on_status_changed()


func _on_status_changed() -> void:
	if not status:
		return
	
	#Check if status depleted to delete it
	if status.can_expire and status.duration <= 0:
		queue_free()
	
	if status.stack_type == Status.StackType.INTENSIFY and status.stacks == 0:
		queue_free()
	
	#Update label texts
	duration.text = str(status.duration)
	stacks.text = str(status.stacks)
