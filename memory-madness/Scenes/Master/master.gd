extends Control

@onready var main: Control = $Main
@onready var game: Control = $Game


func _ready() -> void:
	SignalHub.on_level_selected.connect(on_level_selected)
	SignalHub.on_game_exit_pressed.connect(on_exit_selected)

func show_game(checker: bool) -> void:
	main.visible = !checker
	game.visible = checker

func on_level_selected(level_setting: LevelSetting) -> void:
	show_game(true)

func on_exit_selected() -> void:
	show_game(false)
