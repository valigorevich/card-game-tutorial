class_name CardPile
extends Resource

#Signal when card pile size changed with the amount of card in pile as a parameter
signal card_pile_size_changed(cards_amount)

@export var cards: Array[Card] = []

#Check if card pile is empty
func empty() -> bool:
	return cards.is_empty()
	
#Draw a card
func draw_card() -> Card:
	var card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card

#Add a card to a pile
func add_card(card: Card) -> void:
	cards.append(card)
	card_pile_size_changed.emit(cards.size())
	
#Shuffle card pile
func shuffle() -> void:
	cards.shuffle()
	
#Clear card pile
func clear() -> void:
	cards.clear()
	card_pile_size_changed.emit(cards.size())
	
#Printing function for debugging purposes
func _to_string() -> String:
	var _card_strings: PackedStringArray = []
	for i in range(cards.size()):
		_card_strings.append("%s: %s" % [i+1, cards[i].id])
	return "\n".join(_card_strings)
