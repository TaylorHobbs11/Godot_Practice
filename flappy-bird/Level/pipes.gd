class_name Pipes extends Node2D

@export var _scroll_speed: float = 120

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position.x -= _scroll_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_pipe_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Collision detected with the player and a pipe")
		body.death()


func _on_score_body_entered(body: Node2D) -> void:
	if body is Player:
		print("You have scored")
		GameManager.current_score += 1
