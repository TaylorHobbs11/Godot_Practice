@tool
extends PathFollow2D


@export var move_speed: float = 64.0
@export var ping_pong: bool = true
var _direction: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ping_pong: 
		loop = false
	else:
		loop = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		progress += move_speed * delta * _direction
	
	if progress_ratio > 0.99 and _direction == 1:
		_direction = -1
	if progress_ratio < 0.01 and _direction == -1:
		_direction = 1
