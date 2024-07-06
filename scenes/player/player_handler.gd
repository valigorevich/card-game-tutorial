class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.25

@export var player: Player
@export var hand: Hand

var character: CharacterStats


func start_battle(character_stats: CharacterStats) -> void:
	character = character_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	character.exhaust = CardPile.new()
	player.status_handler.statuses_applied.connect(_on_statuses_applied)
	start_turn()
	

func start_turn() -> void:
	character.block = 0
	character.reset_mana()
	
	#Apply statuses before player turn starts
	player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
	#When all statuses are applied, a statuses_applied signal is emited from statu_handler.
	#So _on_status_applied is called.


func end_turn() -> void:
	hand.switch_hand_state()
	
	#Apply statuses when player turn ends
	player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
	#When all statuses are applied, a statuses_applied signal is emited from statu_handler.
	#So _on_status_applied is called.


func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	#reshuffle_deck_from_discard()


func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
		
	tween.finished.connect(
		func(): Events.player_hand_drawn.emit()
	)


func discard_cards() -> void:
	if hand.get_child_count() == 0:
		Events.player_hand_discarded.emit()
		return
	
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(
		func(): Events.player_hand_discarded.emit()
	)


func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.empty():
		return
	
	while not character.discard.empty():
		character.draw_pile.add_card(character.discard.draw_card())
	
	character.draw_pile.shuffle()


#Callback function that called when a signal emited that all statuses are applied.
func _on_statuses_applied(type: Status.Type) -> void:
	match type:
		Status.Type.START_OF_TURN:
			draw_cards(character.cards_per_turn)
		Status.Type.END_OF_TURN:
			discard_cards()
