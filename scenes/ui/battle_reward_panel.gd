class_name BattleRewardPanel
extends Panel

@onready var continue_button: Button = $VBoxContainer/ContinueButton


func _ready() -> void:
	Events.enemy_wave_cleaned.connect(show_reward_screen)


func show_reward_screen() -> void:
	show()
	get_tree().paused = true


func _on_continue_button_pressed() -> void:
	hide()
	get_tree().paused = false
	Events.enemy_wave_started.emit()
