extends CharacterBody2D


@export_category("Vertical Movement")
@export var _thrust: float = 256
@export var _terminal_velocity: float = 1024
@onready var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Fly"):
		velocity.y = _thrust * -1
	else:
		flying_physics(delta)
	move_and_slide()

func flying_physics(delta: float) -> void:
	velocity.y += _gravity * delta
	velocity.y = min(velocity.y, _terminal_velocity)
