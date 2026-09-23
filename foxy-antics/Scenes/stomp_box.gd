class_name StompBox extends Area2D


signal stomped

@export var explosion: PackedScene
@export var pickup: PackedScene
@export_range(0.0, 1.0) var pickup_chance: float = 0.8
@export var points: int = 5

var _hit: bool = false

var is_hit: bool:
	get: return _hit

func trigger() -> void:
	if _hit: 
		return
	_hit = true
	stomped.emit()
