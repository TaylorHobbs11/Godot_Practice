extends Character

@onready var _ball: CharacterBody2D = %Ball

var _ball_pos: Vector2 
var _distance: Vector2

func _physics_process(delta: float) -> void:
	_ball_pos = _ball.global_position
	_distance = global_position - _ball_pos
	if abs(_distance.y) > _move_speed * delta:
		velocity.y += _move_speed * delta * (1 if _distance.y < 0 else -1)
	else:
		velocity.y = _distance.y
	move_and_slide()
