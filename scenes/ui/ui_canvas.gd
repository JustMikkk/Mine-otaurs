class_name UICanvas
extends CanvasLayer

var _rescued_count: int = 0

@onready var _rescued_amount: Label = %RescuedAmount
@onready var _pickaxe_progress_bar: TextureProgressBar = %PickaxeProgressBar
@onready var _torch_progress_bar: TextureProgressBar = %TorchProgressBar


func _ready() -> void:
	EventBus.person_rescued.connect(func():
		_rescued_count += 1
		_rescued_amount.text = str(_rescued_count, "/14")
	)


func set_torch_value(val: float) -> void:
	_torch_progress_bar.value = val


func update_pick_value() -> void:
	_pickaxe_progress_bar.value = float(GameManager.pick_durability) / GameManager.max_pick_durability
