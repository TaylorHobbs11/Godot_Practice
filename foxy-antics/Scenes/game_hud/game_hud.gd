extends Control

@onready var level_label: Label = $ColorRect/MarginContainer/HBoxContainer/LevelLabel
@onready var coins_label: Label = $ColorRect/MarginContainer/HBoxContainer/HBoxCoins/CoinsLabel
@onready var score_label: Label = $ColorRect/MarginContainer/HBoxContainer/ScoreLabel
@onready var timer: Timer = $Timer
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var lose_sound: AudioStreamPlayer = $LoseSound
@onready var game_over_rect: ColorRect = $GameOverRect
@onready var result_label: Label = $GameOverRect/VBoxContainer/ResultLabel
@onready var h_box_hearts: HBoxContainer = $ColorRect/MarginContainer/HBoxHearts
@onready var complete_level: Label = $GameOverRect/VBoxContainer/CompleteLevel

var _total_coins: int = 0
var _coins_collected: int = 0
var _total_enemies: int = 0
var _enemies_killed: int = 0
var _did_complete: bool = false
var _can_continue: bool = false
var _hearts: Array[TextureRect] = []


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		GameManager.load_main()
	if event.is_action_pressed("Reload"):
		GameManager.reload_current_level()
	if event.is_action_pressed("Next"):
		GameManager.load_next_level()
	if event.is_action_pressed("Jump") and _can_continue:
		if _did_complete:
			GameManager.load_next_level()
		else:
			GameManager.load_main()

func _ready() -> void:
	get_tree().paused = false
	
	for child in h_box_hearts.get_children():
		if child is TextureRect:
			_hearts.append(child)
	
	level_label.text = "Level: %02d" % (GameManager.current_level + 1)
	_total_coins = get_tree().get_nodes_in_group(Coin.GROUP_NAME).size()
	_total_enemies = get_tree().get_nodes_in_group(EnemyBase.GROUP_NAME).size()
	
	SignalHub.coin_collected.connect(on_coin_collected)
	SignalHub.enemy_killed.connect(on_enemy_killed)
	SignalHub.level_completed.connect(on_level_completed)
	SignalHub.player_hit.connect(on_player_hit)
	ScoreManager.score_changed.connect(on_score_changed)
	
	on_score_changed()
	refresh_labels()

func refresh_labels() -> void:
	coins_label.text = "%02d/%02d" % [_coins_collected, _total_coins]

func on_coin_collected() -> void:
	_coins_collected += 1
	refresh_labels()

func on_score_changed() -> void:
	score_label.text = "%04d" % [ScoreManager.current_run_score]
	
func on_enemy_killed() -> void:
	_enemies_killed += 1

func on_level_completed() -> void:
	_did_complete = true
	level_ended()

func level_ended() -> void:
	get_tree().paused = true
	timer.start()
	game_over_rect.show()
	if _did_complete:
		win_sound.play()
	else:
		complete_level.text = "Game Over!"
		lose_sound.play()
	
	result_label.text = "%02d/%02d coins\n%d/%d enemies killed" % [_coins_collected, _total_coins, _enemies_killed, _total_enemies]
	
func on_player_hit(lives: int) -> void:
	for i in range(_hearts.size()):
		_hearts[i].visible = lives > i
	if lives <= 0:
		_did_complete = false
		level_ended()

func _on_timer_timeout() -> void:
	_can_continue = true
