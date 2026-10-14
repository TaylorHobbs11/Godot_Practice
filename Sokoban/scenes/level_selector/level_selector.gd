extends Control

const LEVEL_BUTTON = preload("res://scenes/game_ui/level_button.tscn")

@onready var grid_container: GridContainer = $MC/VB/GridContainer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.load_level("1")

func _ready() -> void:
	for level in LevelData.get_level_names():
		var new_button: Button = LEVEL_BUTTON.instantiate()
		new_button.text = level
		grid_container.add_child(new_button)
