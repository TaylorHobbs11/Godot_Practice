extends EnemyBase

enum ChickenState { WALK, FLY}
@onready var flying_cooldown: Timer = $FlyingCooldown

@export var jump_force: float = -256.0
@export var jump_lifetime: float = 3.0
@export var gravity_curve: Curve
var _in_air: float = 0.0
var _gravity_multiplier: float = 1.0

var _state: ChickenState = ChickenState.WALK

func _ready() -> void:
	change_state(ChickenState.WALK)

func _apply_gravity(delta: float) -> void:
	if _state == ChickenState.FLY and gravity_curve:
		var t: float = clampf(_in_air / jump_lifetime, 0.0, 1.0)
		_gravity_multiplier = gravity_curve.sample(t)
	velocity.y += _gravity * delta * _gravity_multiplier

func _update_behaviour(delta: float) -> void:
	match _state:
		ChickenState.WALK:
			handle_lateral_movement()
		ChickenState.FLY:
			_in_air += delta
			if is_on_floor() and velocity.y >= 0:
				change_state(ChickenState.WALK)

func change_state(new_state: ChickenState) -> void:
	if _hit:
		return
	_state = new_state
	_gravity_multiplier = 1.0
	match _state:
		ChickenState.WALK:
			animated_sprite_2d.play("Walk")
			flying_cooldown.start()
		ChickenState.FLY:
			_in_air = 0.0
			velocity.y = jump_force
			animated_sprite_2d.play("Fly")

func _on_flying_cooldown_timeout() -> void:
	change_state(ChickenState.FLY)

func _on_stomp_box_stomped() -> void:
	super()
	flying_cooldown.stop()
