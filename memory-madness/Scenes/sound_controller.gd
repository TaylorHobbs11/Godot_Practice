extends Node


@export var main_menu_music: AudioStream
@export var game_music: AudioStream
@export var click_effect: AudioStream
@export var tile_effect: AudioStream
@export var game_over_effect: AudioStream

@onready var music: AudioStreamPlayer = $Music
@onready var effects: AudioStreamPlayer = $Effects


func _ready() -> void:
	SignalHub.on_level_selected.connect(on_level_selected)
	SignalHub.on_tile_selected.connect(on_tile_selected)
	SignalHub.on_game_over.connect(on_game_over)
	SignalHub.on_game_exit_pressed.connect(on_game_exit_pressed)
	on_game_exit_pressed()

func play_music(stream: AudioStream) -> void:
	music.stream = stream
	music.play()

func play_effect(stream: AudioStream) -> void:
	effects.stream = stream
	effects.play()

func on_level_selected(_level: LevelSetting):
	play_music(game_music)
	play_effect(click_effect)

func on_tile_selected(_tile: MemoryTile):
	play_effect(tile_effect)

func on_game_over(_moves_taken: int):
	play_effect(game_over_effect)

func on_game_exit_pressed():
	play_music(main_menu_music)
	play_effect(click_effect)
