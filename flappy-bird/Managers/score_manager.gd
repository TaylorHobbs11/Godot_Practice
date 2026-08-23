extends Node

const SAVE_PATH: String = "user://flappy_save.dat"

var current_score: int = 0
var high_score: int = 0

func _ready() -> void:
	load_from_file()
	SignalHub.player_died.connect(on_player_death)

func on_player_death() -> void:
	if current_score > high_score:
		high_score = current_score
		save_to_file()
	reset_score()

func reset_score() -> void:
	current_score = 0

func add_point() -> void:
	current_score += 1
	SignalHub.emit_point_scored(current_score)

func save_to_file():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if !file: return
	file.store_32(high_score)

func load_from_file():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if !file: return
	high_score = file.get_32()
 
