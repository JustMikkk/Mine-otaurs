extends Node


@export var _player_1: Node2D
@export var _player_2: Node2D


func _on_timer_timeout() -> void:
	if _player_1.global_position.y > _player_2.global_position.y:
		_player_1.z_index = 10
		_player_2.z_index = 5
	else:
		_player_1.z_index = 5
		_player_2.z_index = 10
