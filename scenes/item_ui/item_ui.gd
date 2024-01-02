class_name ItemUI
extends Control


const BASE_STYLEBOX := preload("res://scenes/item_ui/item_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/item_ui/item_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/item_ui/item_hover_stylebox.tres")


@onready var item_state_machine: ItemStateMachine = $ItemStateMachine as ItemStateMachine

@export var item: Resource : set = _set_item
# @export var character_stats: CharacterStats : set = _set_character_stats

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
# @onready var item_state_machine: ItemStateMachine = $ItemStateMachine as ItemStateMachine

var disabled = false
var playable = false
var selectable = true
var parent: Control
func _ready() -> void:
	item_state_machine.init(self)


func _input(event: InputEvent) -> void:
	item_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	item_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	item_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	item_state_machine.on_mouse_exited()


func _set_item(value: Resource) -> void:
	if not is_node_ready():
		await ready
	
	item = value
	cost.text = str(item.cost)
	icon.texture = item.icon

	
