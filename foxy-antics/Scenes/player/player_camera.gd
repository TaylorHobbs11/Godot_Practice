class_name PlayerCamera
extends Camera2D

@export var shake_time: float = 0.3
@export var shake_amount: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	offset = Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)

func hit() -> void:
	set_process(true)
	await get_tree().create_timer(shake_time, false).timeout
	set_process(false)
	offset = Vector2.ZERO
