extends Control
class_name ControlUiBase

const BASE_STYLEBOX := preload("res://scenes/item_ui/item_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/item_ui/item_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/item_ui/item_hover_stylebox.tres")

@export var item: Resource:
	set = _set_item
@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon

var parent: Control

var state_machine
var child

func init(props):
	self.state_machine = props.state_machine
	self.child = props.child
	state_machine.init(child)

func _input(event: InputEvent) -> void:
	self.state_machine.on_input(event)


func _on_gui_input(event: InputEvent) -> void:
	self.state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	self.state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	self.state_machine.on_mouse_exited()


func _set_item(value: Resource) -> void:
	if not is_node_ready():
		await ready

	item = value
	cost.text = str(item.cost)
	icon.texture = item.icon
