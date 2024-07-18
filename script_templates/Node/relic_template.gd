# Meta-name: Relic
# meta-description: Create a Relic which can be acquired by player
extends Relic

var member_var := 0

func initialize_relic(_owner: RelicUI) -> void:
	print("This happens when we gain a new relic")


func activate_relic(_owner: RelicUI) -> void:
	#Create all main logic here
	print("This happens at specific times based on Relic.Type propoerty")


func deactivate_relic(_owner: RelicUI) -> void:
	# This called once when a RelicUI is exiting a scene tree i.e. getting deleted
	# Event-based relics should disconnect from event bus here
	pass


# Use for dynamic UI numbers
func get_tooltip() -> String:
	return tooltip
