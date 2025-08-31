class_name Person
extends Entity


func lock_in(new_target: Vector2i) -> void:
	is_locked_in = true
	_goal = new_target
	_navigation_agent_2d.target_position = _goal
	
	await _navigation_agent_2d.target_reached
	
	EventBus.person_rescued.emit()
	$AnimationPlayer.play("celebrate")
