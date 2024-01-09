class_name ItemUI
extends ControlUiBase

@onready var item_state_machine: ItemStateMachine = $ItemStateMachine as ItemStateMachine

var disabled = false
var playable = false
var selectable = true

func init(props):
	super(props)

func _ready() -> void:
	var props = {
		state_machine = item_state_machine,
		child = self
	}
	self.init(props)
