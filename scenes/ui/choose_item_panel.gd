class_name ChooseItemPanel
extends GridContainer

var list_counter = 0

@onready var item_ui = preload("res://scenes/item_ui/item_ui.tscn")


func render(
	card_list: CardPile,
):
	if list_counter < len(card_list.cards):
		for card in card_list.cards:
			var item_ui_instance := item_ui.instantiate()
			self.add_child(item_ui_instance)
			item_ui_instance.item = card
			item_ui_instance.parent = self
			item_ui_instance.disabled = true
			item_ui_instance.selectable = true
			list_counter += 1
