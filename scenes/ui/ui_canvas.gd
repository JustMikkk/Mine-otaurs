class_name UICanvas
extends CanvasLayer

var _rescued_count: int = 0

var _tween_pickaxe: Tween
var _tween_result: Tween

@onready var _rescued_amount: Label = %RescuedAmount
@onready var _pickaxe_progress_bar: TextureProgressBar = %PickaxeProgressBar
@onready var _torch_progress_bar: TextureProgressBar = %TorchProgressBar
@onready var _result_screen: TextureRect = $Control/ResultScreen


func _ready() -> void:
	EventBus.person_rescued.connect(func():
		_rescued_count += 1
		_rescued_amount.text = str(_rescued_count, "/14")
		if _rescued_count == 12:
			show_result_screen()
	)


func show_result_screen() -> void:
	if _tween_result:
		_tween_result.kill()
	
	_tween_result = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_result.tween_property(_result_screen, "position:y", 100, 0.4)
	_tween_result.tween_callback(func():
		GameManager.main_camera.add_trauma(0.3)
	)


func set_torch_value(val: float) -> void:
	_torch_progress_bar.value = val


func update_pick_value() -> void:
	if _tween_pickaxe:
		_tween_pickaxe.kill()
	
	_tween_pickaxe = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	_tween_pickaxe.tween_property(_pickaxe_progress_bar, "value", float(GameManager.pick_durability) / GameManager.max_pick_durability, 0.3)
