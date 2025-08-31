extends Camera2D

const CAMERA_SPEED = 10
const SLOW_CAMERA_SPEED = 3

@export var _player1: Player
@export var _player2: Player


func _process(delta: float) -> void:
	var goal:Vector2=global_position
	var speed = CAMERA_SPEED
	if _player1._current_state!=Player.State.FROZEN and _player2._current_state!=Player.State.FROZEN:
		goal = (_player1.global_position + _player2.global_position) / 2
	elif _player1._current_state!=Player.State.FROZEN:
		goal = _player1.global_position 
		speed = SLOW_CAMERA_SPEED
	elif _player2._current_state!=Player.State.FROZEN:
		goal =  _player2.global_position
		speed = SLOW_CAMERA_SPEED
	global_position = lerp(global_position, goal, speed * delta)
