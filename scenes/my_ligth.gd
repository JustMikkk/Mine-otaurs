extends Sprite2D
class_name TorchLigth
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

func _ready() -> void:
	power=max_power
	ligth_id=li.register_ligth(self,power)
	low_power_time = low_power_max_time
	if register:
		SoundPlayer.torch=self

func _process(delta: float) -> void:
	if limited:
		power-=delta*power_dec
		power=max(power,0.0)
		if power<low_power and low_power_time>0.0:
			power=low_power
			low_power_time-=delta
		li.lights_int[ligth_id]=power
		#print(power)
	if Input.is_key_pressed(KEY_U):
		power=max_power
		low_power_time=low_power_max_time

func refill():
	power=max_power
	low_power_time=low_power_max_time
