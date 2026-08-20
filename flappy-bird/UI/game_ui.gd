class_name GameUI extends Control

@onready var _gameover: Label = $MarginContainer/Gameover
@onready var _press_jump: Label = $MarginContainer/PressJump
@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var _timer: Timer = $Timer

func _ready() -> void:
	SignalHub.player_died.connect(game_over)
	_press_jump.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu") or (event.is_action_pressed("Jump") and _press_jump.visible == true):
		GameManager.load_main_screen()

func game_over() -> void:
	_gameover.visible = true
	_audio_stream_player.play()
	_timer.start()

func _on_timer_timeout() -> void:
	_gameover.visible = false
	_press_jump.visible = true
	
