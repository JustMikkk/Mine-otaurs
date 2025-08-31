extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not body.has_pickaxe:
			body.get_node("Torch").refill_tween()
	
	if body is Person:
		if body.is_locked_in: return
		
		body.is_locked_in = true
		var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(body, "global_position", global_position, 2)
		tween.tween_interval(2)
		tween.set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
		tween.tween_property(body, "global_position", global_position - Vector2(0, 2000), 1)
		tween.tween_property(body, "scale", Vector2(0.1, 1.9), 1)
		
		
		


#func _on_body_exited(body: Node2D) -> void:
	#if body is Player:
		#if not body.has_pickaxe:
			#body.get_node("Torch").power_dec = 10
