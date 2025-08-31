extends Button

var _tween_scale: Tween
@onready var _initial_y: float = position.y

func _on_mouse_entered() -> void:
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(self, "scale", Vector2(0.55, 0.55), 0.3)


func _on_mouse_exited() -> void:
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(self, "scale", Vector2(0.5, 0.5), 0.3)


func _on_pressed() -> void:
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	modulate = Color(0.9, 0.9, 0.9)
	_tween_scale.tween_property(self, "position:y", _initial_y + 20, 0.1)
	_tween_scale.tween_callback(func():
		modulate = Color.WHITE
	)
	_tween_scale.tween_property(self, "position:y", _initial_y, 0.1)
	
