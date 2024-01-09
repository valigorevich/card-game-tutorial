extends Panel

@onready var player = %Player
@onready var card_list_panel = %CardListPanel
@onready var cards_quantity_label = %NumCards
# @onready var card_ui = preload("res://scenes/card_ui/card_ui.tscn")
@onready var item_ui = preload("res://scenes/item_ui/item_ui.tscn")

var list_counter = 0

func _ready():
	self.hide()


func _on_deck_info_open_button_pressed():
	var card_list: CardPile = player.current_deck
	var cards_count = len(card_list.cards)
	cards_quantity_label.text = "There are %s cards in deck" % cards_count
	print("quantity", cards_count)
	# var stats = player.stats
	for card in card_list.cards:
		if list_counter < cards_count:
			var item_ui_instance := item_ui.instantiate()
			card_list_panel.add_child(item_ui_instance)
			# item_ui_instance.character_stats = stats
			item_ui_instance.item = card
			item_ui_instance.parent = self
			# item_ui_instance.preview_mode = true
			item_ui_instance.disabled = true
			item_ui_instance.global_position += card_list_panel.global_position + Vector2(10, 10)
			item_ui_instance.selectable = false
			list_counter += 1

	self.show()


func _on_button_pressed():
	self.hide()
