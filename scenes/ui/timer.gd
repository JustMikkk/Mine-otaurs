class_name GameTimer
extends Label


var _is_running: bool = false
var _time_elapsed: float = 0


func _ready() -> void:
	start_timer()


func _process(delta: float) -> void:
	if not _is_running: return
	_time_elapsed += delta
	text = format_time(_time_elapsed)


func start_timer() -> void:
	_is_running = true

func stop_timer() -> void:
	_is_running = false


func format_time(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
