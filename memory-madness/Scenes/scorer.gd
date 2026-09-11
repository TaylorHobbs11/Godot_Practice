class_name Scorer extends Node


static var SelectionEnabled: bool = true

@onready var reveal_timer: Timer = $RevealTimer
@onready var pair_sound: AudioStreamPlayer = $PairSound

var _selected_tiles: Array[MemoryTile]
var _pairs_made: int = 0
var _target_pairs: int = 99
var _moves_made: int = 0

func _ready() -> void:
	SignalHub.on_tile_selected.connect(on_tile_selected)
	SignalHub.on_game_exit_pressed.connect(on_exit_selected)

func check_for_pair() -> void:
	if _selected_tiles[0].matches_other_tile(_selected_tiles[1]):
		_selected_tiles[0].kill_on_pair()
		_selected_tiles[1].kill_on_pair()
		_pairs_made += 1
		pair_sound.play()
	_moves_made += 1

func clear_new_game(target_pairs: int) -> void:
	_selected_tiles.clear()
	SelectionEnabled = true
	_pairs_made = 0
	_target_pairs = target_pairs
	_moves_made = 0
 
func get_pairs_str() -> String:
	return "%d / %d" % [_pairs_made, _target_pairs]

func get_moves_str() -> String:
	return "%d" % [_moves_made]

func check_game_over() -> void:
	if _pairs_made != _target_pairs:
		SelectionEnabled = true
	else:
		SignalHub.emit_on_game_over(_moves_made)

func process_pair() -> void:
	if _selected_tiles.size() !=2: return
	
	SelectionEnabled = false
	reveal_timer.start()
	check_for_pair()

func on_tile_selected(tile: MemoryTile) -> void:
	if !SelectionEnabled: return
	if tile in _selected_tiles: return
	_selected_tiles.append(tile)
	process_pair()

func _on_reveal_timer_timeout() -> void:
	for tile in _selected_tiles:
		tile.reveal(false)
	check_game_over()
	_selected_tiles.clear()

func on_exit_selected() -> void:
	reveal_timer.stop()
	_selected_tiles.clear()
	SelectionEnabled = true
