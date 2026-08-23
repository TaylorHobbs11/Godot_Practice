extends Node

signal player_died
signal point_scored(score: int)

func emit_player_died() -> void:
	player_died.emit()

func emit_point_scored(score: int) -> void:
	point_scored.emit(score)
