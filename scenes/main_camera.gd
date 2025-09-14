class_name MainCamera
extends Camera2D

const CAMERA_SPEED = 10
const SLOW_CAMERA_SPEED = 3

@export var _player1: Player
@export var _player2: Player	

@export var decay : float = 0.8 # Time it takes to reach 0% of trauma
@export var max_offset : Vector2 = Vector2(100, 75) # Max hor/ver shake in pixels
@export var max_roll : float = 0.1 # Maximum rotation in radians (use sparingly)
@export var follow_node : Node2D # Node to follow (assign this to your player)

var trauma : float = 0.0 # Current shake strength
var trauma_power : int = 2 # Trauma exponent. Increase for more extreme shaking

var _tween_zoom: Tween


func _ready() -> void:
	#? Randomize the game seed
	randomize()

func _process(delta : float) -> void:
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
	
	#if follow_node: # If the follow node exists
		#global_position = follow_node.global_position # Set the camera's position to the follow node's position
	if trauma: # If the camera is currently shaking
		trauma = max(trauma - decay * delta, 0) # Decay the shake strength
		shake() # Shake the camera

func change_zoom(new_zoom: Vector2) -> void:
	_tween_zoom = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_ignore_time_scale(true)
	_tween_zoom.tween_property(self, "zoom", new_zoom, 0.5)


## The function to use for adding trauma (screen shake)
func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0) # Add the amount of trauma (capped at 1.0)


## This function is used to actually apply the shake to the camera
func shake() -> void:
	#? Set the camera's rotation and offset based on the shake strength
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
