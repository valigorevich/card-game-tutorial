class_name Status
extends Resource

#A signal to notify everybody who is interested that status effect finished it's application
#Important for the cases when we loop through statuses to apply their effect
signal status_applied(status: Status)
#A signal to notify when something (duation or stacks) is changed in status
signal status_changed

#
enum Type {START_OF_TURN, END_OF_TURN, EVENT_BASED}
enum StackType {NONE, INTENSIFY, DURATION}

@export_group("Status Data")
@export var id: String
@export var type: Type
@export var stack_type: StackType
@export var can_expire: bool
@export var duration: int : set = set_duration
@export var stacks: int : set = set_stacks

@export_group("Status Visuals")
@export var icon: Texture
@export_multiline var tooltip: String

#This is called when status comes in to setup connections
func initialize_status(_target: Node) -> void:
	pass


#This is called when status effect actually applied to emit that signal
func apply_status(_target: Node) -> void:
	status_applied.emit(self)
	#Signal catched by status_handler to substruct duration or other stuff


func get_tooltip() -> String:
	return tooltip


func set_duration(new_duration: int) -> void:
	duration = new_duration
	status_changed.emit()


func set_stacks(new_stacks: int) -> void:
	stacks = new_stacks
	status_changed.emit()
