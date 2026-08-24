extends Node

const MAIN_SCENE: PackedScene = preload("res://Level/main.tscn")
const GAME_SCENE: PackedScene = preload("res://Level/game.tscn")
const LOADING_SCREEN: PackedScene = preload("uid://bh6ruiyour4ei")


#region Original
#func load_game_screen() -> void:
	#get_tree().change_scene_to_packed(GAME_SCENE)
#
#func load_main_screen() -> void:
	#get_tree().change_scene_to_packed(MAIN_SCENE)

#endregion

#region SimpleTransition
var _next_scene: PackedScene

func change_to_next() -> void:
	get_tree().change_scene_to_packed(_next_scene)

func load_game_screen() -> void:
	_next_scene = GAME_SCENE
	get_tree().change_scene_to_packed(LOADING_SCREEN)

func load_main_screen() -> void:
	_next_scene = MAIN_SCENE
	get_tree().change_scene_to_packed(LOADING_SCREEN)


#endregion
