class_name LevelLayout
extends RefCounted

enum LayerType { Floor, Wall, Target, Box, TargetBox }

const JSON_KEYS: Dictionary[LayerType, String] = {
	LayerType.Floor: "floor",
	LayerType.Wall: "wall",
	LayerType.Target: "target",
	LayerType.Box: "box",
	LayerType.TargetBox: "target_box"
}

var player_start: Vector2i = Vector2i.ZERO

var _tiles: Dictionary = {
	
}

func get_tiles_for_layers(layer_type: LayerType) -> Array[Vector2i]:
	return _tiles.get(layer_type, [])

func parse(data: Dictionary) -> void:
	var starting_position: Dictionary = data.player_start
	player_start = Vector2i(starting_position.x, starting_position.y)
	
	var tiles: Dictionary = data.tiles
	for layer in JSON_KEYS.keys():
		var coords: Array[Vector2i] = []
		for coord in tiles[JSON_KEYS[layer]]:
			coords.append(Vector2i(coord.x, coord.y))
		_tiles[layer] = coords
		pass
