class_name UICanvas
extends CanvasLayer

var _rescued_count: int = 0

var _tween_pickaxe: Tween
var _tween_result: Tween
var _tween_start: Tween

@onready var _rescued_amount: Label = %RescuedAmount
@onready var _pickaxe_progress_bar: TextureProgressBar = %PickaxeProgressBar
@onready var _torch_progress_bar: TextureProgressBar = %TorchProgressBar
@onready var _result_screen: TextureRect = $Control/ResultScreen
@onready var _start_menu: Control = $Control/StartMenu

@onready var _you_win_label: Label = $Control/ResultScreen/YouWinLabel
@onready var _saved_label: Label = $Control/ResultScreen/SavedLabel
@onready var _time_label: Label = $Control/ResultScreen/TimeLabel

@onready var _timer: GameTimer = $Control/Timer


func _ready() -> void:
	EventBus.person_rescued.connect(func():
		_rescued_count += 1
		_rescued_amount.text = str(_rescued_count, "/14")
		if _rescued_count == 12:
			show_result_screen()
	)


func show_result_screen() -> void:
	_timer.stop_timer()
	
	if _tween_result:
		_tween_result.kill()
	
	if _rescued_count == 12:
		_you_win_label.text = "YOU WIN!"
		_saved_label.text = "Everyone was \nsaved 3:]"
	else:
		_you_win_label.text = "YOU DIED!"
		_saved_label.text = str(_rescued_count, " people \nwere saved")
	
	_time_label.text = "time: " + _timer.text
	
	
	_tween_result = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_result.tween_property(_result_screen, "position:y", 100, 0.4)
	_tween_result.tween_callback(func():
		GameManager.main_camera.add_trauma(0.3)
	)


func hide_result_screen() -> void:
	if _tween_result:
		_tween_result.kill()
	
	_tween_result = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_result.tween_property(_result_screen, "position:y", -800, 0.4)
	#_tween_result.tween_callback(func():
		#GameManager.main_camera.add_trauma(0.3)
	#)



func set_torch_value(val: float) -> void:
	_torch_progress_bar.value = val


func update_pick_value() -> void:
	if _tween_pickaxe:
		_tween_pickaxe.kill()
	
	_tween_pickaxe = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	_tween_pickaxe.tween_property(_pickaxe_progress_bar, "value", float(GameManager.pick_durability) / GameManager.max_pick_durability, 0.3)


func _on_button_reset_pressed() -> void:
	SoundPlayer.p=[]
	GameManager.end()
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_button_exit_pressed() -> void:
	get_tree().quit()


func _on_play_btn_pressed() -> void:
	Engine.time_scale = 1
	
	if _tween_start:
		_tween_start.kill()
	
	_tween_start = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK).set_ignore_time_scale(true)
	_tween_start.tween_property(_start_menu, "position:y", -720, 0.5).set_delay(0.2)
