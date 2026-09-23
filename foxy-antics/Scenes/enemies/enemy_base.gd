class_name EnemyBase extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_detection: RayCast2D = $FloorDetection
@onready var wall_detection: RayCast2D = $WallDetection
@onready var player_detection: RayCast2D = $PlayerDetection
@onready var hit_area: Area2D = $HitArea

@onready var _gravity: float = ProjectSettings.get("physics/2d/default_gravity")

@export_category("Lateral Movement")
@export var _movement_speed: float = 32.0
var _direction: int = -1


func _physics_process(delta: float) -> void:
	_update_behaviour(delta)
	_apply_gravity(delta)
	move_and_slide()

func _apply_gravity(delta: float) -> void:
	velocity.y += _gravity * delta

func _update_behaviour(_delta: float) -> void:
	pass

func turn_around_sprite() -> void:
	animated_sprite_2d.flip_h = _direction == 1


func turn_around_raycast() -> void:
	floor_detection.position.x *= -1
	wall_detection.target_position.x *= -1
	player_detection.target_position.x *= -1

func handle_lateral_movement() -> void:
	if wall_detection.is_colliding() or not floor_detection.is_colliding():
		_direction = -_direction
		turn_around_sprite()
		turn_around_raycast()
	velocity.x = _movement_speed * _direction
	

func _on_stomp_box_stomped() -> void:
	animated_sprite_2d.play("Hurt")
	set_physics_process.call_deferred(false)
	hit_area.set_monitorable.call_deferred(false)


func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "Hurt":
		queue_free()
