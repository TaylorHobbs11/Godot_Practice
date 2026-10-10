extends Node

const SCORE_PATH: String = "user://foxyantics.res"
const LEVEL_BONUS: int = 60

signal score_changed

var current_run_score: int = 0
var high_scores: HighScores

var _levels_completed: int = 0

func _ready() -> void:
	load_scores()
	SignalHub.scored.connect(update_score)
	SignalHub.level_completed.connect(on_level_completed)

func on_level_completed() -> void:
	_levels_completed += 1
	update_score(LEVEL_BONUS * _levels_completed)
	
func update_score(points: int) -> void:
	current_run_score += points
	score_changed.emit()

func reset_score() -> void:
	current_run_score = 0
	_levels_completed = 0

func commit_run() -> void:
	if current_run_score <= 0: 
		return
	high_scores.add_scores(current_run_score)
	save_scores()
	reset_score()

func load_scores() -> void:
	if FileAccess.file_exists(SCORE_PATH):
		high_scores = load(SCORE_PATH) as HighScores
	if not high_scores:
		high_scores = HighScores.new()
	
func save_scores() -> void:
	ResourceSaver.save(high_scores, SCORE_PATH)
