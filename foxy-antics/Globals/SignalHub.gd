extends Node

signal spawn_scene(position: Vector2, scene: PackedScene)
signal spawn_score_effect(position: Vector2, points: int)
signal spawn_bullet(velocity: Vector2, start_position: Vector2, scene: PackedScene)
signal coin_collected
signal level_completed
signal enemy_killed
signal player_hit(lives: int)
signal scored(points: int)

func emit_spawn_scene(position: Vector2, scene: PackedScene) -> void:
	spawn_scene.emit(position, scene)

func emit_spawn_bullet(velocity: Vector2, start_position: Vector2, scene: PackedScene) -> void:
	spawn_bullet.emit(velocity, start_position, scene)

func emit_coin_collected() -> void:
	coin_collected.emit()

func emit_scored(points: int) -> void:
	scored.emit(points)

func emit_level_completed() -> void:
	level_completed.emit()

func emit_enemy_killed() -> void:
	enemy_killed.emit()

func emit_player_hit(lives: int) -> void:
	player_hit.emit(lives)

func emit_spawn_score_effect(position: Vector2, points: int):
	spawn_score_effect.emit(position, points)
