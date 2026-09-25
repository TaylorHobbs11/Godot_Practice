extends Node2D


@export var bullet_speed: float = 80.0
@export var bullet_scene: PackedScene
@export var shoot_time: float = 3.0

@onready var shooting_cooldown: Timer = $ShootingCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var muzzle: Marker2D = $Muzzle
@onready var sprite_2d: Sprite2D = $Sprite2D

var _player_reference: Player

func _ready() -> void:
	_player_reference = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if !_player_reference:
		printerr("No player found")
		queue_free()
		return

func _process(delta: float) -> void:
	var flip: bool = _player_reference.global_position.x > global_position.x
	if flip != sprite_2d.flip_h:
		sprite_2d.flip_h = flip
		muzzle.position.x *= -1

func shoot() -> void:
	if !bullet_scene:
		return
	var direction: Vector2 = muzzle.global_position.direction_to(_player_reference.global_position)
	SignalHub.emit_spawn_bullet(direction * bullet_speed, muzzle.global_position, bullet_scene)
	shoot_sound.play()

func start_timer() -> void:
	shooting_cooldown.start(shoot_time * randf_range(0.8, 1.2))

func _on_shooting_cooldown_timeout() -> void:
	animation_player.play("Shoot")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	start_timer()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	shooting_cooldown.stop()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Shoot":
		animation_player.play("Idle")
		start_timer()
