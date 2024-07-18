class_name Battle
extends Node2D

@export var battle_stats: BattleStats
@export var character_stats: CharacterStats
@export var music: AudioStream
@export var relics: RelicHandler

@onready var battle_ui := $BattleUI as BattleUI
@onready var player_handler := $PlayerHandler as PlayerHandler
@onready var enemy_handler := $EnemyHandler as EnemyHandler
@onready var player := $Player as Player
@onready var hand: Hand = %Hand


func _ready() -> void:
	hand.player = player
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)

func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	
	battle_ui.character_stats = character_stats
	player.stats = character_stats
	player_handler.relics = relics
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	
	#Activate start of combat relics
	relics.relics_activated.connect(_on_relics_activated)
	relics.activate_relics_by_type(Relic.Type.START_OF_COMBAT)


func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0 and is_instance_valid(relics):
		# Must check for valid instance because we call this when close the game (crash)
		relics.activate_relics_by_type(Relic.Type.END_OF_COMBAT)


func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOOSE)


func _on_relics_activated(type: Relic.Type) -> void:
	match type:
		Relic.Type.START_OF_COMBAT:
			player_handler.start_battle(character_stats)
			battle_ui.initialize_card_pile_ui()
		Relic.Type.END_OF_COMBAT:
			Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)
