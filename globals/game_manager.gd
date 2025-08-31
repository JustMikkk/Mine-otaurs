extends Node


var max_pick_durability: int = 4

@onready var pick_durability: int = max_pick_durability
@onready var ui_canvas: UICanvas = get_tree().get_first_node_in_group("UICanvas")
@onready var torch: Torch = get_tree().get_first_node_in_group("Torch") 


func _ready() -> void:
	EventBus.pick_used.connect(func():
		pick_durability = max(0, pick_durability -1)
		ui_canvas.update_pick_value()
	)
