extends Node

const SCORE_EFFECT = preload("res://Scenes/Effects/score_effect.tscn")


func _ready() -> void:
	SignalHub.spawn_scene.connect(on_spawn_scene)
	SignalHub.spawn_bullet.connect(on_spawn_bullet)
	SignalHub.spawn_score_effect.connect(on_spawn_score_effect)

func on_spawn_scene(position: Vector2, scene: PackedScene) -> void:
	if !scene:
		return
	var node_scene = scene.instantiate()
	
	if node_scene is Node2D:
		node_scene.global_position = position
		add_child.call_deferred(node_scene)

func on_spawn_bullet(velocity: Vector2, start_position: Vector2, scene: PackedScene) -> void:
	if !scene:
		return
	var new_bullet: Bullet = scene.instantiate()
	new_bullet.setup(velocity, start_position)
	add_child.call_deferred(new_bullet)

func on_spawn_score_effect(position: Vector2, points: int) -> void:
	var new_score_effect: ScoreEffect = SCORE_EFFECT.instantiate()
	new_score_effect.position = position
	new_score_effect.setup(points)
	add_child.call_deferred(new_score_effect)
