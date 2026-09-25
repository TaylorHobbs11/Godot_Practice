extends Area2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_sound: AudioStreamPlayer = $PickupSound


func _ready() -> void:
	animated_sprite_2d.animation = (animated_sprite_2d.sprite_frames.get_animation_names() as Array[String]).pick_random()
	animated_sprite_2d.play()


func _on_pickup_sound_finished() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		animated_sprite_2d.hide()
		pickup_sound.play()


func _on_pickup_available_timer_timeout() -> void:
	monitoring = true
