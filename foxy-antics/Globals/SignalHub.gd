extends Node

signal spawn_scene(position: Vector2, scene: PackedScene)
signal spawn_bullet(velocity: Vector2, start_position: Vector2, scene: PackedScene)

func emit_spawn_scene(position: Vector2, scene: PackedScene) -> void:
	spawn_scene.emit(position, scene)

func emit_spawn_bullet(velocity: Vector2, start_position: Vector2, scene: PackedScene) -> void:
	spawn_bullet.emit(velocity, start_position, scene)
