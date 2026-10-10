@tool
extends Node2D

@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D

@export var offset: Vector2 = Vector2(0, -200):
	set(value):
		offset = value
		start_tween()
@export var duration: float = 4.0:
	set(value):
		duration = value
		start_tween()




var _tween: Tween

func _ready() -> void:
	start_tween()
	
func start_tween() -> void:
	if !is_node_ready():
		return
	if _tween: 
		_tween.kill()
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(animatable_body_2d, "position", offset, duration / 2)
	_tween.tween_property(animatable_body_2d, "position", Vector2.ZERO, duration / 2)
