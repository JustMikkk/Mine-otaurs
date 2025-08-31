extends Sprite2D
@export var li:MyLigth
@export var max_power:float=200
var power
@export var limited:bool=false
@export var power_dec=50.0
var ligth_id
func _ready() -> void:
	power=max_power
	ligth_id=li.register_ligth(self,power)

func _process(delta: float) -> void:
	if limited:
		power-=delta*power_dec
		power=max(power,0.0)
		li.lights_int[ligth_id]=power
	if Input.is_key_pressed(KEY_U):
		power=max_power
