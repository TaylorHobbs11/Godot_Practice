extends Node


func _ready() -> void:
	SignalHub.spawn_scene.connect(on_spawn_scene)
	SignalHub.spawn_bullet.connect(on_spawn_bullet)

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
