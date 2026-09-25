extends EnemyBase

enum PigState { IDLE, WALK, RAGE}

@onready var rage_cooldown: Timer = $RageCooldown
@onready var rage_time: Timer = $RageTime

@export var _rage_speed: float = 64.0

var _state: PigState = PigState.WALK

var _can_rage: bool = true
var _player_ref: Player

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if !_player_ref:
		printerr("No player detected")
		queue_free()
	change_state(PigState.WALK)

func _update_behaviour(_delta: float) -> void:
	match _state:
		PigState.IDLE:
			handle_idle()
			align_raycasts()
		PigState.WALK:
			handle_lateral_movement()
			detect_player()
		PigState.RAGE:
			handle_rage_lateral_movement()

func change_state(new_state: PigState) -> void:
	if _hit:
		return
	_state = new_state
	match _state:
		PigState.IDLE:
			animated_sprite_2d.offset.y = -15
			animated_sprite_2d.play("Idle")
		PigState.WALK:
			animated_sprite_2d.offset.y = -13
			animated_sprite_2d.play("Walk")
		PigState.RAGE:
			animated_sprite_2d.offset.y = -14
			animated_sprite_2d.play("Rage_Run")

func detect_player() -> void:
	if player_detection.is_colliding():
		change_state(PigState.RAGE)

func handle_idle() -> void:
	set_physics_process.call_deferred(false)

func handle_rage_lateral_movement() -> void:
	if _can_rage:
		rage_time.start()
	_direction = sign(_player_ref.global_position.x - global_position.x)
	velocity.x = _rage_speed * _direction
	turn_around_sprite()
	_can_rage = false
	
func align_raycasts() -> void:
	if sign(wall_detection.target_position.x) != _direction:
		turn_around_raycast()

func _on_rage_time_timeout() -> void:
	change_state(PigState.IDLE)
	rage_cooldown.start()


func _on_rage_cooldown_timeout() -> void:
	_can_rage = true
	change_state(PigState.WALK)
	set_physics_process.call_deferred(true)

func _on_animation_finished() -> void:
	super()
	animated_sprite_2d.offset.y = -15
	
