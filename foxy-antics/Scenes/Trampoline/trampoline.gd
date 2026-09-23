class_name Trampoline extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var boing_sound: AudioStreamPlayer = $BoingSound

@export var bounce_velocity: Vector2 = Vector2(0.0, -512.0)

var is_active: bool:
	get: return animated_sprite_2d.is_playing()

func bounce() -> void:
	animated_sprite_2d.play("Trampoline_Trigger")
	boing_sound.play()
