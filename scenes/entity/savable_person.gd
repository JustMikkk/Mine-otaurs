extends CharacterBody2D

const MOVEMENT_SPEED = 9800.0

@export var _goal: Node2D

@onready var _navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	_navigation_agent_2d.target_position = _goal.global_position


func _physics_process(delta: float) -> void:
	if not _navigation_agent_2d.is_target_reached():
		var nav_point_direction: Vector2 = to_local(_navigation_agent_2d.get_next_path_position()).normalized()
		velocity = nav_point_direction * MOVEMENT_SPEED * delta
		move_and_slide()


func _on_timer_timeout() -> void:
	if _navigation_agent_2d.target_position == _goal.global_position:
		return
	_navigation_agent_2d.target_position = _goal.global_position
	
