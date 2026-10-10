extends Node

const MAIN = preload("res://Scenes/Main/main.tscn")

const LEVEL_SCENES: Array[PackedScene] = [
	preload("res://Scenes/level_base/level_1.tscn"),
	preload("res://Scenes/level_base/level_2.tscn"),
	preload("res://Scenes/level_base/level_3.tscn")
]

var current_level: int:
	get: return _current_level

var _current_level: int = -1

func load_next_level() -> void:
	_current_level += 1
	if _current_level >= LEVEL_SCENES.size():
		_current_level = 0
	get_tree().change_scene_to_packed(LEVEL_SCENES[_current_level])

func load_main() -> void:
	_current_level = -1
	ScoreManager.commit_run()
	get_tree().change_scene_to_packed(MAIN)

func reload_current_level() -> void:
	if _current_level < 0 or _current_level >= LEVEL_SCENES.size():
		return
		
	get_tree().change_scene_to_packed(LEVEL_SCENES[_current_level])
