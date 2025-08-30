extends TileMapLayer

func _process(delta: float) -> void:
	visible=!Input.is_key_pressed(KEY_K)
