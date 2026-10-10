class_name ScoreEffect
extends Node2D

@onready var label: Label = $Label

var _score: int = 0

func setup(score: int) -> void:
	_score = score

func _ready() -> void:
	label.text = "%02d" % _score

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
