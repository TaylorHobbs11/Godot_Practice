class_name Player extends CharacterBody2D

@onready var _bird: AnimatedSprite2D = $Bird

@export_category("Movement")
@export var _jump_velocity: float = 256
@export var _terminal_velocity: float = 1028
@onready var _gravity: float = ProjectSettings.get("physics/2d/default_gravity")
@onready var _flying_sound: AudioStreamPlayer2D = $FlyingSound

var current_rotation: float = 0
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		velocity.y = _jump_velocity * -1
		_flying_sound.play()
	else:
		velocity.y += _gravity * delta
		velocity.y = min(velocity.y, _terminal_velocity)
	rotate_bird(delta)
	move_and_slide()

	if is_on_floor(): death()

func rotate_bird(delta: float) ->void:
	if velocity.y > 0:
		rotation = move_toward(current_rotation, rad_to_deg(PI / 4), delta * 2)
		if not _bird.is_playing(): 
			_bird.play("default")
	elif velocity.y < 0:
		rotation = move_toward(current_rotation, rad_to_deg(-PI / 4), delta * 3)
		_bird.play("Flap")
	rotation_degrees = clampf(rotation_degrees, -45, 45)
	current_rotation = rotation 
	

func death() -> void:
	SignalHub.emit_player_died()
	get_tree().paused = true
	
