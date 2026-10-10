extends Control

const UI_LABEL_24 = preload("res://Resources/Text/UILabel24.tres")
@onready var score_grid: GridContainer = $MarginContainer/ScoreGrid

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		GameManager.load_next_level()

func _ready() -> void:
	get_tree().paused = false
	add_high_scores()

func add_high_scores() -> void:
	print("High Scores")
	for i in range(ScoreManager.high_scores.scores.size()):
		var label: Label = Label.new()
		label.text = "%02d. %05d" % [i + 1, ScoreManager.high_scores.scores[i]]
		label.label_settings = UI_LABEL_24
		score_grid.add_child(label)
