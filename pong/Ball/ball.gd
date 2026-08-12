extends CharacterBody2D

@export_category("Movement")
@export var _move_speed: float = 256
var _direction: Vector2
@onready var _ball: Sprite2D = $BallSprite
@onready var _trail: Sprite2D = $BallSprite/TrailSprite
@onready var _timer: Timer = $Timer

func _ready() -> void:
	_randomize_direction()

func _randomize_direction() -> void:
	var random_x = [-1, 1].pick_random()
	var random_y = randf_range(-0.8, 0.8)
	_direction = Vector2(random_x, random_y).normalized()
	_trail.rotation = rad_to_deg(_direction.angle())

func _reset() -> void:
	_direction = Vector2.ZERO
	_move_speed = 256
	position = get_viewport_rect().size / 2
	_timer.start()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(_direction * _move_speed * delta)
	
	if collision:
		_direction = _direction.bounce(collision.get_normal())
		var collider = collision.get_collider()
		
		if collider.is_in_group("paddle"):
			_move_speed += 32
			_direction = new_direction(collider).bounce(collision.get_normal())

func new_direction(collider: CharacterBody2D) -> Vector2:
	var ball_y: float = global_position.y
	var paddle_y: float = collider.global_position.y
	var dist: float = ball_y - paddle_y
	var new_dir: Vector2
	
	if _direction.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (120.0 / 2))
	print(new_dir)
	return new_dir.normalized()

func _on_timer_timeout() -> void:
	_randomize_direction()
