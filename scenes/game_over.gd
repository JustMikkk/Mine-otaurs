extends ColorRect

@export var players:Array[Player]


func _process(delta: float) -> void:
	var stuckState=[Player.State.FROZEN,Player.State.STUN]
	if (players[0]._current_state in stuckState) and (players[1]._current_state in stuckState):
		visible=true
	else:
		visible=false


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")
