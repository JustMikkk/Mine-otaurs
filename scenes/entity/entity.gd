class_name Entity
extends CharacterBody2D

@export var _movement_speed: float = 12000.0

var is_locked_in := false

var _light_id: int
var _is_frozen := false

@onready var _light: MyLigth = get_tree().get_first_node_in_group("myLight")
@onready var _goal: Vector2 = global_position
@onready var _players: Array = get_tree().get_nodes_in_group("Players")
@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var _navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	_light_id = _light.register_sensor(self)
	_navigation_agent_2d.target_position = _players[0].global_position


func _physics_process(delta: float) -> void:
	var light_value: int = _light.get_sensor_data(_light_id)
	
	#print(light_value)
	if light_value < 8:
		_animated_sprite_2d.modulate = Color(0.1, 0.1, 0.1)
		_is_frozen = true
		return
	else:
		_animated_sprite_2d.modulate = Color.WHITE
		_is_frozen = false
	
	if not _navigation_agent_2d.is_target_reached():
		var nav_point_direction: Vector2 = to_local(_navigation_agent_2d.get_next_path_position()).normalized()
		velocity = nav_point_direction * _movement_speed * delta
		_animate()
		move_and_slide()


func _on_timer_timeout() -> void:
	if _is_frozen or is_locked_in: return
	
	if not is_locked_in:
		var goal_id=0
		if global_position.distance_to(_players[0].global_position) > global_position.distance_to(_players[1].global_position):
			_goal = _players[1]
			goal_id = 1
		else:
			_goal = _players[0]
			goal_id = 0
		if _goal._current_state==Player.State.STUN:
			goal_id=1-goal_id
			_goal=_players[goal_id]
		
	
	if global_position.distance_to(_players[closer_player_index].global_position) < 128 * 3 \
	and not _players[closer_player_index].is_frozen():
		_goal = _players[closer_player_index].global_position
	
	elif global_position.distance_to(_players[other_player_index].global_position) < 128 * 3 \
	and not _players[other_player_index].is_frozen():
		_goal = _players[other_player_index].global_position
	
	if _navigation_agent_2d.target_position == _goal:
		return
	
	_navigation_agent_2d.target_position = _goal


func _animate() -> void:
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			_animated_sprite_2d.animation = "right"
		else:
			_animated_sprite_2d.animation = "left"
	else:
		if velocity.y > 0:
			_animated_sprite_2d.animation = "down"
		else:
			_animated_sprite_2d.animation = "up" 
