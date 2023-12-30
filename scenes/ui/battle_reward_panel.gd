class_name BattleRewardPanel
extends Panel

@onready var choose_item_panel: = %ChooseItemPanel as ChooseItemPanel
@onready var continue_button: Button = $VBoxContainer/ContinueButton

var current_player: Player
var selected_reward

func _ready() -> void:
	Events.enemy_wave_cleaned.connect(show_reward_screen)
	Events.card_selected.connect(_on_card_selection)
	continue_button.disabled = true


func show_reward_screen(rewads, player) -> void:
	current_player = player
	show()
	get_tree().paused = true
	choose_item_panel.render(rewads, player.stats)


func _on_continue_button_pressed() -> void:
	current_player.current_deck.add_card(selected_reward)
	hide()
	get_tree().paused = false
	Events.enemy_wave_started.emit()

func _on_card_selection(card_ui):
	continue_button.disabled = false
	selected_reward = card_ui.card