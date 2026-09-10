extends Control

const MEMORY_TILE = preload("res://Scenes/memory_tile.tscn")
@onready var grid_container: GridContainer = $HBoxContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.on_level_selected.connect(on_level_selected)



func on_level_selected(level_setting: LevelSetting) -> void:
	
	var level_data_selector: LevelDataSelector = LevelDataSelector.new()
	var selected_images: Array[Texture2D] = level_data_selector.get_images_for_level(level_setting)
	var frame_image: Texture2D = ImageMaster.get_random_frame_image()
	
	grid_container.columns = level_setting.columns
	for image in selected_images:
		var mt: MemoryTile = MEMORY_TILE.instantiate()
		grid_container.add_child(mt)
		mt.setup(image, frame_image)


func _on_exit_button_pressed() -> void:
	for tile in grid_container.get_children():
		tile.queue_free()
		SignalHub.emit_on_game_exit_pressed()
