class_name TorchLigth
extends AnimatedSprite2D
@export var li:MyLigth
@export var max_power:float=200
var power
@export var limited:bool=false
@export var power_dec=50.0
var ligth_id
var low_power=25.0
var low_power_max_time=5.0
var low_power_time=0.0
@export var register=false

var _tween_refill: Tween

func _ready() -> void:
	power=max_power
	ligth_id=li.register_ligth(self,power)
	low_power_time = low_power_max_time
	
	EventBus.torch_used.connect(func():
		power -= max_power / 4.0
		GameManager.ui_canvas.set_torch_value(power / float(max_power))
	)
	
	if register:
		SoundPlayer.torch=self

func _process(delta: float) -> void:
	if limited:
		power-=delta*power_dec
		power=max(power,0.0)
		GameManager.ui_canvas.set_torch_value(power / float(max_power))
		if power<low_power and low_power_time>0.0:
			power=low_power
			low_power_time-=delta
		if Input.is_key_pressed(KEY_SHIFT):
			li.lights_int[ligth_id]=min(power,40)
		else:
			li.lights_int[ligth_id]=power
		#print(power)
	if Input.is_key_pressed(KEY_U):
		power=max_power
		low_power_time=low_power_max_time


func refill():
	print("ref")
	if(power<max_power/2):
		SoundPlayer.make_sound(SoundPlayer.Sounds.FIRE)
	#SoundPlayer.make_sound(SoundPlayer.Sounds.FIRE)
	power=max_power
	low_power_time=low_power_max_time
	
	


func refill_tween() -> void:
	low_power_time = low_power_max_time
	
	if _tween_refill:
		_tween_refill.kill()
	
	_tween_refill = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	_tween_refill.tween_method(_set_power, power, max_power, 1)
	if power<0.7*max_power:
		SoundPlayer.make_sound(SoundPlayer.Sounds.FIRE)


func _set_power(val: float) -> void:
	power = val
