extends Panel

@onready var player = %Player
@onready var card_list_panel = %CardListPanel

@onready var card_ui = preload("res://scenes/card_ui/card_ui.tscn")

var list_counter = 0


func _ready():
	self.hide()


func _on_deck_info_open_button_pressed():
	var card_list: CardPile = player.current_deck

	# print(card_list._to_string())
	if list_counter < len(card_list.cards):
		for card in card_list.cards:
			print(card)
			var new_card_ui := card_ui.instantiate()
			card_list_panel.add_child(new_card_ui)
			new_card_ui.character_stats = player.stats
			new_card_ui.card = card
			new_card_ui.parent = self
			new_card_ui.disabled = true
			new_card_ui.global_position += card_list_panel.global_position + Vector2(10, 10)
			list_counter += 1

	self.show()


func _on_button_pressed():
	self.hide()
