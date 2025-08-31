extends ColorRect

@export var players:Array[Player]
@export var on:bool=false

func _process(delta: float) -> void:
	await get_tree().create_timer(1).timeout
	if on:
		var stuckState=[Player.State.FROZEN,Player.State.STUN]
		if (players[0]._current_state in stuckState) and (players[1]._current_state in stuckState):
			GameManager.ui_canvas.show_result_screen()
		else:
			GameManager.ui_canvas.hide_result_screen()
