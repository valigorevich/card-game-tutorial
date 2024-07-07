#A base class for all enemy actions
class_name EnemyAction
extends Node

enum Type {CONDITIONAL, CHANCE_BASED}

@export var intent: Intent
@export var sound: AudioStream
@export var type: Type
@export_range(0.0, 100.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

var enemy: Enemy
var target: Node2D


#Virtual function which check the conditions for conditional actions
func is_performable() -> bool:
	return false
	
#Virtual function for actual action stuff
func perform_action() -> void:
	pass


#Virtual function to update intent text based on dynamic numbers
func update_intent_text() -> void:
	#for text with no modifiers
	intent.current_text = intent.base_text
	#Dynamic texts overrides in specific enemy actions. See enemy_action_template
