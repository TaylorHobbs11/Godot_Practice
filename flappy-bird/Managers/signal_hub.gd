extends Node

signal player_died

func emit_player_died() -> void:
	player_died.emit()
