class_name BattleUI
extends CanvasLayer

@export var character_stats: CharacterStats : set = _set_character_stats

@onready var hand: Hand = $Hand as Hand
@onready var mana_ui: ManaUI = $ManaUI as ManaUI
@onready var end_turn_button: Button = %EndTurnButton


func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)


func _set_character_stats(value: CharacterStats) -> void:
	character_stats = value
	mana_ui.character_stats = character_stats
	hand.character_stats = character_stats


func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false
	hand.switch_hand_state()


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
