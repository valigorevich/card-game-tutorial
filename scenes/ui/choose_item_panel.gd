class_name ChooseItemPanel
extends HBoxContainer

var list_counter = 0
@onready var card_ui = preload("res://scenes/card_ui/card_ui.tscn")


func render(card_list: CardPile, stats):
	if list_counter < len(card_list.cards):
		for card in card_list.cards:
			var new_card_ui := card_ui.instantiate()
			self.add_child(new_card_ui)
			new_card_ui.character_stats = stats
			new_card_ui.card = card
			new_card_ui.parent = self
			new_card_ui.preview_mode = true
			new_card_ui.disabled = true
			# new_card_ui.global_position += card_list_panel.global_position + Vector2(10, 10)
			list_counter += 1
