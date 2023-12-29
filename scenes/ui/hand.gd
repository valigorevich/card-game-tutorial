class_name Hand
extends HBoxContainer

@export var character_stats: CharacterStats

@onready var card_ui = preload("res://scenes/card_ui/card_ui.tscn")

func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	
	
func add_card(card: Card) -> void:
	var new_card_ui := card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.character_stats = character_stats
	new_card_ui.disabled = true


func discard_card(card: CardUI) -> void:
	card.queue_free()


func switch_hand_state() -> void:
	for card in get_children():
		card.disabled = not card.disabled

	
func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.reparent(self)
	#we need to reparent a card to the index where it was originaly. Index is updated when any card is played.
	move_child.call_deferred(child, child.original_index)

func _on_card_played(card: Card) -> void:
	character_stats.discard.add_card(card)
	#Iterate through hand to get new indexes and save for reparent.
	for child in get_children():
		var hand_card_ui := child as CardUI
		hand_card_ui.original_index = hand_card_ui.get_index()
