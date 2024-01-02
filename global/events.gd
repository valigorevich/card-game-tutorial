extends Node

#Card-related signals
signal card_drag_started(card_iu: CardUI)
signal card_drag_ended(card_iu: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal tooltip_requested(icon: Texture, text: String)
signal card_selected(card_ui: CardUI)
signal item_selected(item_ui: ItemUI)
signal tooltip_hide_requested

#Player-related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died

#Enemy related signals
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended

#Battle-related events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal enemy_wave_started
signal enemy_wave_cleaned
