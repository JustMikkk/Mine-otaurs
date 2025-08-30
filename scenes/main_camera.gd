extends Camera2D

const CAMERA_SPEED = 10


@export var _player1: Player
@export var _player2: Player


func _process(delta: float) -> void:
	global_position = lerp(global_position, (_player1.global_position + _player2.global_position) / 2, CAMERA_SPEED * delta)
