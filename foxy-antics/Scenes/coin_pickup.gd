class_name Coin extends Pickup


const GROUP_NAME: String = "Coin"



func _ready() -> void:
	animated_sprite_2d.play()

func _on_body_entered(body: Node2D) -> void:
	super(body)
	SignalHub.emit_coin_collected()

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
