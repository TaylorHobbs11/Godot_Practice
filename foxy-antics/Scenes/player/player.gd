class_name Player extends CharacterBody2D

@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var hurt_sound: AudioStreamPlayer = $HurtSound

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_timer: Timer = $HurtTimer

@export_category("Invincibility")
@export var _flash_count: int = 5
@export var _flash_duration: float = 0.2

@export_category("Locomotion")
@export var _movement_speed: int = 128
@export var _terminal_velocity: int = 512
@export var _jump_velocity: int = -256
@export var _hurt_velocity: Vector2 = Vector2(0.0, -64.0)
@export var _stomp_velocity: float = -192
var _direction: float
var _start_position: Vector2

@export_category("Camera Controls")
@export var camera_left: int = -10000
@export var camera_right: int = 10000
@export var camera_top: int = -10000
@export var camera_bottom: int = 10000
@onready var player_camera: Camera2D = $PlayerCamera

var _damage_areas: Array[Area2D]

var is_still: bool:
	get: return is_zero_approx(velocity.x)
var is_falling: bool:
	get: return velocity.y > 0
var is_jumping: bool = false
var was_on_floor: bool = false
var is_hurt: bool = false
var is_invincible: bool = false
var _invincible_tween: Tween

@onready var _gravity: float = ProjectSettings.get("physics/2d/default_gravity")

func _ready() -> void:
	_start_position = position
	set_camera_limits()
	
func set_camera_limits() -> void:
	player_camera.limit_bottom = camera_bottom
	player_camera.limit_top = camera_top
	player_camera.limit_left = camera_left
	player_camera.limit_right = camera_right


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and is_on_floor():
		is_jumping = true

func _physics_process(delta: float) -> void:
	handle_lateral_movement()
	handle_vertical_movement(delta)
	flip_sprite()
	move_and_slide()
	check_landing()

func flip_sprite() -> void:
	if not is_zero_approx(_direction):
		sprite_2d.flip_h = velocity.x < 0

func check_landing() -> void:
	if not was_on_floor and is_on_floor():
		land_sound.play()
	was_on_floor = is_on_floor()

func handle_lateral_movement() -> void:
	if is_hurt:
		return
	_direction = Input.get_axis("Left", "Right")
	velocity.x = _direction * _movement_speed

func handle_vertical_movement(delta: float) -> void:
	if is_hurt:
		return
	if is_jumping and is_on_floor():
		velocity.y = _jump_velocity
		jump_sound.play()
		is_jumping = false
	else:
		velocity.y += _gravity * delta
		velocity.y = minf(velocity.y, _terminal_velocity)
	
func fell_off() -> void:
	position = _start_position
	set_position.call_deferred(_start_position)

func go_invincible() -> void:
	if is_invincible: return
	is_invincible = true
	if _invincible_tween and _invincible_tween.is_running():
		_invincible_tween.kill()
	_invincible_tween = create_tween()
	_invincible_tween.set_loops(_flash_count)
	_invincible_tween.tween_property(self, "modulate", Color.TRANSPARENT, _flash_duration)
	_invincible_tween.tween_property(self, "modulate", Color.WHITE, _flash_duration)
	_invincible_tween.finished.connect(invincible_finished)

func invincible_finished() -> void:
	is_invincible = false
	if _damage_areas.size() > 0:
		apply_hit.call_deferred()

func apply_hurt_jump() -> void:
	if is_hurt:
		return
	is_hurt = true
	hurt_timer.start()
	hurt_sound.play()
	velocity = _hurt_velocity

func apply_hit() -> void:
	if is_invincible:
		return
	apply_hurt_jump()
	go_invincible()

func apply_stomp() -> void:
	velocity.y = _stomp_velocity

func apply_bounce(bounce_velocity: Vector2) -> void:
	velocity = bounce_velocity


func _on_hit_area_area_entered(area: Area2D) -> void:
	print("Player hit by " + area.name)
	apply_hit.call_deferred()
	if area not in _damage_areas:
		_damage_areas.append(area)
	
func _on_hit_area_area_exited(area: Area2D) -> void:
	print("Player left " + area.name)
	_damage_areas.erase(area)

func _on_hurt_timer_timeout() -> void:
	is_hurt = false


func _on_stomp_area_area_entered(area: Area2D) -> void:
	if velocity.y < 0.0 or is_hurt:
		return
	if area is StompBox and not area.is_hit:
		print("Collided with " + area.name)
		apply_stomp.call_deferred()
		area.trigger()
	
	if area is Trampoline and not area.is_active:
		print("Collided with " + area.name)
		apply_bounce.call_deferred(area.bounce_velocity)
		area.bounce()
