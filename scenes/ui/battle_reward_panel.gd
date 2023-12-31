class_name BattleRewardPanel
extends Panel

@onready var choose_item_panel := %ChooseItemPanel as ChooseItemPanel
@onready var continue_button: Button = $VBoxContainer/ContinueButton

@onready var reward_manager = get_parent().get_node("%RewardManager")

var current_player: Player
var selected_reward
var reward_variants


func _ready() -> void:
	Events.enemy_wave_cleaned.connect(show_reward_screen)
	Events.card_selected.connect(_on_card_selection)
	continue_button.disabled = true
	if not reward_manager.is_node_ready():
		await reward_manager.ready
	reward_manager.calculate_wave_reward()
	reward_variants = reward_manager.current_reward
	print(reward_variants)


func show_reward_screen(player) -> void:
	current_player = player
	show()
	get_tree().paused = true
	choose_item_panel.render(reward_variants, player.stats)


func _on_continue_button_pressed() -> void:
	current_player.current_deck.add_card(selected_reward)
	hide()
	get_tree().paused = false
	Events.enemy_wave_started.emit()


func _on_card_selection(card_ui):
	continue_button.disabled = false
	selected_reward = card_ui.card
