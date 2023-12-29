class_name GameLevelLable
extends Label


func _ready():
	Events.game_level_changed.connect(_on_game_level_changed)

func _on_game_level_changed(level) -> void:
	self.text = "Level: %s" % level
