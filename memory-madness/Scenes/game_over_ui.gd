extends PanelContainer

@onready var moves_label: Label = $VBoxContainer/MovesLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.on_game_over.connect(on_game_over)
	SignalHub.on_game_exit_pressed.connect(on_game_exit_pressed)

func on_game_over(moves_taken: int) -> void:
	show()
	moves_label.text = "You took %d moves" % [moves_taken]

func on_game_exit_pressed() -> void:
	hide()
