extends Node2D

@export var character_stats: CharacterStats
@export var music: AudioStream
@export var battle_scenario: BattleScenario

@export var current_game_level = 1
@export var wave_rewards: Array[CardPile] = []

@onready var battle_ui := $BattleUI as BattleUI
@onready var player_handler := $PlayerHandler as PlayerHandler
@onready var enemy_handler := $EnemyHandler as EnemyHandler
@onready var scenario_handler := $ScenarioHandler as ScenarioHandler
@onready var player := $Player as Player


func _ready() -> void:
	var new_stats: CharacterStats = character_stats.create_instance()
	battle_ui.character_stats = new_stats
	player.stats = new_stats

	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.enemy_wave_started.connect(start_next_wave)

	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(_on_player_hand_discarded)
	Events.player_died.connect(_on_player_died)

	start_battle(new_stats)


func start_battle(stats: CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)	
	battle_ui._on_game_level_changed(current_game_level)
	scenario_handler.spawn_wave(battle_scenario, current_game_level)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)


func start_next_wave() -> void:
	increment_game_level()
	scenario_handler.spawn_wave(battle_scenario, current_game_level)
	enemy_handler.reset_enemy_actions()
	player_handler.start_turn()


func increment_game_level():
	current_game_level += 1
	battle_ui._on_game_level_changed(current_game_level)


func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()


func _on_player_hand_discarded() -> void:
	if enemy_handler.get_child_count() > 0:
		enemy_handler.start_turn()
	else:
		var reward = calculate_wave_reward()
		print(reward)
		Events.enemy_wave_cleaned.emit(reward, player.stats)

func calculate_wave_reward():
	return wave_rewards[current_game_level]

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		player_handler.end_turn()


func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOOSE)
