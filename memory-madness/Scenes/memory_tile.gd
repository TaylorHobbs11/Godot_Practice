class_name MemoryTile extends TextureButton

@onready var frame_image: TextureRect = $FrameImage
@onready var item_image: TextureRect = $ItemImage

func _ready() -> void:
	reveal(false)

func setup(image: Texture2D, frame: Texture2D) -> void:
	frame_image.texture = frame
	item_image.texture = image

func reveal(r: bool) -> void:
	frame_image.visible = r
	item_image.visible = r


func _on_pressed() -> void:
	if !Scorer.SelectionEnabled: return
	reveal(true)
	SignalHub.emit_on_tile_selected(self)
