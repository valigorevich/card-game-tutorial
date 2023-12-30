class_name BattleRewardPanel
extends Panel

@onready var choose_item_panel: = %ChooseItemPanel as ChooseItemPanel
@onready var continue_button: Button = $VBoxContainer/ContinueButton


func _ready() -> void:
	Events.enemy_wave_cleaned.connect(show_reward_screen)


func show_reward_screen(rewads, stats) -> void:
	show()
	get_tree().paused = true
	choose_item_panel.render(rewads, stats)


func _on_continue_button_pressed() -> void:
	hide()
	get_tree().paused = false
	Events.enemy_wave_started.emit()
