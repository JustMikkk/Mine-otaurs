extends Area2D


@export var _avaliable_places: Array[Vector2]
var _people_count: int = 0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_pickaxe:
			GameManager.pick_durability = GameManager.max_pick_durability
			GameManager.ui_canvas.update_pick_value()
		else:
			body.get_node("Torch").refill_tween()
	
	if body is Person:
		if body.is_locked_in: return
		
		body.lock_in(global_position + _avaliable_places[_people_count] * 128 + Vector2.ONE * 64)
		_people_count += 1
		#body.is_locked_in = true
		#var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		#tween.tween_property(body, "global_position", global_position, 2)
		#tween.tween_interval(2)
		#tween.set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
		#tween.tween_property(body, "global_position", global_position - Vector2(0, 2000), 1)
		#tween.tween_property(body, "scale", Vector2(0.1, 1.9), 1)
		#tween.set_parallel(false)
		#tween.tween_callback(func():
		#)





#func _on_body_exited(body: Node2D) -> void:
	#if body is Player:
		#if not body.has_pickaxe:
			#body.get_node("Torch").power_dec = 10
