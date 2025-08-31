class_name Enemy
extends Entity

var target=null
var time2hit=0.0

func take_damage() -> void:
	_animated_sprite_2d.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	_animated_sprite_2d.modulate = Color.WHITE
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		print("HIT")
		target=body
		time2hit=0.3
		#body.take_damage()
func _process(delta: float) -> void:
	if target!=null:
		time2hit-=delta
		if time2hit<0.0:
			print("HIT DEAL")
			target.take_damage()
			target=null
