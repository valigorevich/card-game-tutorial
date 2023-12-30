extends Node

#Card-related signals
signal card_drag_started(card_iu: CardUI)
signal card_drag_ended(card_iu: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
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

#Game state signals
signal game_level_changed(level: int)
