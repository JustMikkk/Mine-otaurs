extends Node


var max_pick_durability: int = 4


var frozen_players: int = 0:
	set(val):
		frozen_players = val
		if frozen_players == 2 and Time.get_ticks_msec() > 5000:
			print("big loos")


@onready var pick_durability: int = max_pick_durability
@onready var ui_canvas: UICanvas = get_tree().get_first_node_in_group("UICanvas")
@onready var torch: TorchLigth = get_tree().get_first_node_in_group("Torch") 
@onready var main_camera: MainCamera = get_tree().get_first_node_in_group("MainCamera")

func _ready() -> void:
	EventBus.pick_used.connect(func():
		pick_durability = max(0, pick_durability -1)
		ui_canvas.update_pick_value()
	)
