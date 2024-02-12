class_name CharacterStats
extends Stats

@export_group("Visuals")
@export var character_name: String
@export_multiline var description: String
@export var portrait: Texture

@export_group("Gameplay Data")
@export var starting_deck: CardPile
@export var cards_per_turn: int
@export var max_mana: int

var mana: int : set = set_mana
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile


func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()
	
#Reset mana to its max value. Usualy called every turn
func reset_mana() -> void:
	self.mana = max_mana


func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage) #call take damage function from class we inherited from
	if initial_health > health:
		Events.player_hit.emit()


#Check if we can play a card
func can_play_card(card: Card) -> bool:
	return mana >= card.cost


#Create an instance of this resource
func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	instance.discard = CardPile.new()
	instance.draw_pile = CardPile.new()
	return instance
