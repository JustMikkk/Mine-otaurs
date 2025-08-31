class_name Enemy
extends Entity


func take_damage() -> void:
	_animated_sprite_2d.modulate = Color.WHITE
	await get_tree().create_timer(0.05).timeout
	_animated_sprite_2d.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
