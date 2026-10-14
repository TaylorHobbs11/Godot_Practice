extends Node

const SOURCE_ID: int = 0
const NOT_SOURCE_ID: int = -1

const ATLAS_COORDS: Dictionary[LevelLayout.LayerType, Vector2i] = {
	LevelLayout.LayerType.Floor: Vector2i(4,0),
	LevelLayout.LayerType.Wall: Vector2i(0,0),
	LevelLayout.LayerType.Target: Vector2i(3,0),
	LevelLayout.LayerType.TargetBox: Vector2i(2,0),
	LevelLayout.LayerType.Box: Vector2i(1,0),
}

@onready var floors: TileMapLayer = $Tiles/FloorTiles
@onready var walls: TileMapLayer = $Tiles/WallTiles
@onready var targets: TileMapLayer = $Tiles/TargetTiles
@onready var boxes: TileMapLayer = $Tiles/BoxTiles
@onready var tiles: Node2D = $Tiles
@onready var player: AnimatedSprite2D = $Player
@onready var game_ui: GameUi = $CanvasLayer/GameUi


var _player_tile: Vector2i
var _game_over: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.load_main()
	elif event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	else:
		move_player(get_input_direciton())

func get_input_direciton() -> Vector2i:
	var move_direction: Vector2i = Vector2i.ZERO
	
	if Input.is_action_just_pressed("ui_right"):
		move_direction = Vector2i.RIGHT
		player.play("Right")
	if Input.is_action_just_pressed("ui_left"):
		move_direction = Vector2i.LEFT
		player.play("Left")
	if Input.is_action_just_pressed("ui_up"):
		move_direction = Vector2i.UP
		player.play("Up")
	if Input.is_action_just_pressed("ui_down"):
		move_direction = Vector2i.DOWN
		player.play("Down")

	return move_direction
	
func _ready() -> void:
	setup_level()

func check_game_state() -> void:
	for t in targets.get_used_cells():
		if not cell_is_box(t):
			return
	_game_over = true
	game_ui.game_over()

func cell_is_wall(cell: Vector2i) -> bool:
	return walls.get_cell_source_id(cell) != NOT_SOURCE_ID

func cell_is_box(cell: Vector2i) -> bool:
	return boxes.get_cell_source_id(cell) != NOT_SOURCE_ID

func cell_is_empty(cell: Vector2i) -> bool:
	return !cell_is_wall(cell) and !cell_is_box(cell)

func box_can_move(box_cell: Vector2i, direction: Vector2i) -> bool:
	return cell_is_empty(box_cell + direction)

func move_box(box_cell: Vector2i, direction: Vector2i) -> void:
	var destination: Vector2i = box_cell + direction
	boxes.erase_cell(box_cell)
	
	var layer_type: LevelLayout.LayerType = LevelLayout.LayerType.Box
	
	if destination in targets.get_used_cells():
		layer_type = LevelLayout.LayerType.TargetBox
	
	boxes.set_cell(destination, SOURCE_ID, ATLAS_COORDS[layer_type])
		

func move_player(direction: Vector2i) -> void:
	if direction == Vector2i.ZERO:
		return
	var destination: Vector2i = _player_tile + direction
	if cell_is_wall(destination):
		return
	if cell_is_box(destination) and !box_can_move(destination, direction):
		return
	
	if cell_is_box(destination):
		move_box(destination, direction)
	
	game_ui.add_move()
	place_player_on_tile(direction + _player_tile)
	check_game_state()

func clear_all_tiles() -> void:
	var children: Array = tiles.get_children()
	for child in children:
		if child is TileMapLayer:
			child.clear()

func center_map() -> void:
	var map_middle: Vector2i = floors.get_used_rect().get_center()
	var map_middle_pixels: Vector2 = floors.to_global(floors.map_to_local(map_middle))
	tiles.position = floors.get_viewport_rect().get_center() - map_middle_pixels
	
func place_player_on_tile(destination: Vector2i) -> void:
	player.global_position = floors.to_global(floors.map_to_local(destination))
	_player_tile = destination
	
func setup_layer(layer_type: LevelLayout.LayerType, map_layer: TileMapLayer, layout: LevelLayout) -> void:
	for tile_coord in layout.get_tiles_for_layers(layer_type):
		map_layer.set_cell(tile_coord, SOURCE_ID, ATLAS_COORDS[layer_type])

func setup_level() -> void:
	clear_all_tiles()
	
	var level_layout: LevelLayout = LevelData.get_level_data(GameManager.level_selected)
	
	setup_layer(level_layout.LayerType.Floor, floors, level_layout)
	setup_layer(level_layout.LayerType.Wall, walls, level_layout)
	setup_layer(level_layout.LayerType.Target, targets, level_layout)
	setup_layer(level_layout.LayerType.TargetBox, boxes, level_layout)
	setup_layer(level_layout.LayerType.Box, boxes, level_layout)
	
	center_map()
	place_player_on_tile(level_layout.player_start)
