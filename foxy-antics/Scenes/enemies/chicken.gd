extends EnemyBase

enum ChickenState { WALK, FLY}
@onready var flying_cooldown: Timer = $FlyingCooldown

@export var jump_force: float = -256.0

var _state: ChickenState = ChickenState.WALK

func _ready() -> void:
	change_state(ChickenState.WALK)

func _update_behaviour(_delta: float) -> void:
	match _state:
		ChickenState.WALK:
			handle_lateral_movement()
		ChickenState.FLY:
			if is_on_floor() and velocity.y >= 0:
				change_state(ChickenState.WALK)

func change_state(new_state: ChickenState) -> void:
	_state = new_state
	match _state:
		ChickenState.WALK:
			animated_sprite_2d.play("Walk")
			flying_cooldown.start()
		ChickenState.FLY:
			velocity.y = jump_force
			animated_sprite_2d.play("Fly")

func _on_flying_cooldown_timeout() -> void:
	change_state(ChickenState.FLY)

func _on_stomp_box_stomped() -> void:
	super()
	flying_cooldown.stop()
