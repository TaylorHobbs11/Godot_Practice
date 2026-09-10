extends Node

const TILE_IMAGES: TileImageHolder = preload("res://Resources/TileImages.tres")

func get_random_item_image() -> Texture2D:
	return TILE_IMAGES.tile_images.pick_random()
