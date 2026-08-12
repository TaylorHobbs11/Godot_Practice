extends Node2D

@onready var _player_score: Label = $CanvasLayer/PlayerScore
@onready var _computer_score: Label = $CanvasLayer/ComputerScore
var _scoreboard: Array[int] = [0,0]
var new_node: Node2D

func _ready() -> void:
	update_score()


func update_score() -> void:
	_player_score.text = str(_scoreboard[0])
	_computer_score.text = str(_scoreboard[1])
	
	

func _on_player_goal_body_entered(_body: Node2D) -> void:
	_scoreboard[0] += 1
	update_score()


func _on_computer_goal_body_entered(_body: Node2D) -> void:
	_scoreboard[1] += 1
	update_score()
