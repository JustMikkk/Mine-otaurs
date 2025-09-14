class_name Person
extends Entity

func _enter_tree() -> void:
	is_looking_for_someone=false
	#$AnimationPlayer.play("celebrate")

func lock_in(new_target: Vector2i) -> void:
	is_locked_in = true

	_navigation_agent_2d.target_position = new_target
	
	await _navigation_agent_2d.target_reached
	
	EventBus.person_rescued.emit()
	$AnimationPlayer.play("celebrate")


func _process(delta: float) -> void:
	if not is_looking_for_someone:
		for pl in SoundPlayer.p:
			if pl.global_position.distance_to(global_position)<80.0:
				is_looking_for_someone=true
				_highlight()
				

func _highlight() -> void:
	modulate = Color.SKY_BLUE
	await get_tree().create_timer(0.25).timeout
	modulate = Color.WHITE
