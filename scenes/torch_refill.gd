extends Node2D

@export var p:Player

func _process(delta: float) -> void:
	if p.global_position.distance_to(global_position)<100.0:
		p.get_node("Torch").refill()
