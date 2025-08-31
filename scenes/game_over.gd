extends ColorRect

@export var players:Array[Player]
@export var on:bool=false

func _process(delta: float) -> void:
	if on:
		var stuckState=[Player.State.FROZEN,Player.State.STUN]
		if (players[0]._current_state in stuckState) and (players[1]._current_state in stuckState):
			visible=true
		else:
			visible=false
	if Input.is_action_just_pressed("ui_cancel"):
		_on_button_pressed()


func _on_button_pressed() -> void:
	SoundPlayer.p=[]
	GameManager.end()
	get_tree().change_scene_to_file("res://scenes/level.tscn")
