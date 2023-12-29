extends Node2D

@export var character_stats: CharacterStats
@export var music: AudioStream
@export var enemy_spawner: EnemySpawner

@export var current_game_level = 1

@onready var battle_ui := $BattleUI as BattleUI
@onready var player_handler := $PlayerHandler as PlayerHandler
@onready var enemy_handler := $EnemyHandler as EnemyHandler
@onready var player := $Player as Player


func _ready() -> void:
	var new_stats: CharacterStats = character_stats.create_instance()
	battle_ui.character_stats = new_stats
	player.stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	Events.game_level_changed.emit(current_game_level)
	start_battle(new_stats)

#to_do: function to spawn enemies in enemy handler.
#match current level with enemy spawner level.
#select enemies and spawn them one by one.
#if current level > enemy spawner level -> win
#when spawn animation ended, call start_battle.

func start_battle(stats: CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)

func increment_game_level():
	current_game_level += 1
	Events.game_level_changed.emit(current_game_level)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		increment_game_level()
		# Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)


func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOOSE)
