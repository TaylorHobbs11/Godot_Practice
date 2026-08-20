class_name Player extends CharacterBody2D

@export_category("Movement")
@export var _jump_velocity: float = 256
@export var _terminal_velocity: float = 1028
@onready var _gravity: float = ProjectSettings.get("physics/2d/default_gravity")
@onready var _flying_sound: AudioStreamPlayer2D = $FlyingSound

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		velocity.y = _jump_velocity * -1
		_flying_sound.play()
	else:
		velocity.y += _gravity * delta
		velocity.y = min(velocity.y, _terminal_velocity)
	move_and_slide()

	if is_on_floor(): death()

func death() -> void:
	SignalHub.emit_player_died()
	get_tree().paused = true
