extends Node

@export var explosion: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Next"):
		var explosion_instance = explosion.instantiate()
		explosion_instance.position = Vector2(randf_range(550.0, 600.0), randf_range(0.0, 400.0))
		add_child(explosion_instance)
		
