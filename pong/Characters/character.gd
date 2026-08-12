class_name Character extends CharacterBody2D


@export_category("Movement")
@export var _move_speed: float = 256



func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("move_up", "move_down")
	if direction:
		velocity.y += _move_speed * delta * direction
	else:
		velocity.y = 0
	move_and_slide()
