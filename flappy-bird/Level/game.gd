extends Node2D

@export var pipe_scene: PackedScene
@onready var highest_spawn_point: Marker2D = $HighestSpawnPoint
@onready var lowest_spawn_point: Marker2D = $LowestSpawnPoint
@onready var _score: Label = $CanvasLayer/Score

var previous_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_pipes()

func _process(_delta: float) -> void:
	var current_score = GameManager.current_score
	if current_score != previous_score:
		previous_score = current_score
		score()
	

func spawn_pipes() -> void:
	var new_pipes: Pipes = pipe_scene.instantiate()
	var random_y_position = randf_range(highest_spawn_point.position.y, lowest_spawn_point.position.y)
	var x_position = highest_spawn_point.position.x
	new_pipes.position = Vector2(x_position, random_y_position)
	add_child(new_pipes)


func _on_timer_timeout() -> void:
	spawn_pipes()


func _on_boundaries_body_entered(body: Node2D) -> void:
	if body is Player:
		body.death()



func score() -> void:
	_score.text = str(GameManager.current_score)
