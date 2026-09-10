class_name Scorer extends Node


static var SelectionEnabled: bool = true

@onready var reveal_timer: Timer = $RevealTimer

var _selected_tiles: Array[MemoryTile]

func _ready() -> void:
	SignalHub.on_tile_selected.connect(on_tile_selected)
	SignalHub.on_game_exit_pressed.connect(on_exit_selected)


func process_pair() -> void:
	if _selected_tiles.size() !=2: return
	
	SelectionEnabled = false
	reveal_timer.start()

func on_tile_selected(tile: MemoryTile) -> void:
	if !SelectionEnabled: return
	if tile in _selected_tiles: return
	_selected_tiles.append(tile)
	process_pair()

func _on_reveal_timer_timeout() -> void:
	for tile in _selected_tiles:
		tile.reveal(false)
	SelectionEnabled = true
	_selected_tiles.clear()

func on_exit_selected() -> void:
	reveal_timer.stop()
	_selected_tiles.clear()
	SelectionEnabled = true
