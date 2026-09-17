extends Node

const LEVEL_BASE = preload("res://Scenes/level_base/level_base.tscn")
const MAIN = preload("res://Scenes/Main/main.tscn")

func load_level() -> void:
	get_tree().change_scene_to_packed(LEVEL_BASE)

func load_main() -> void:
	get_tree().change_scene_to_packed(MAIN)
