extends Node

signal on_level_selected(level_setting: LevelSetting)
signal on_game_exit_pressed

func emit_on_level_selected(level_setting: LevelSetting) -> void:
	on_level_selected.emit(level_setting)

func emit_on_game_exit_pressed() -> void:
	on_game_exit_pressed.emit()
