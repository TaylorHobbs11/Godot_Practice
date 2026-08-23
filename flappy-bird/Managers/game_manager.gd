extends Node

const MAIN_SCENE: PackedScene = preload("res://Level/main.tscn")
const GAME_SCENE: PackedScene = preload("res://Level/game.tscn")

func load_game_screen() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)

func load_main_screen() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE)
