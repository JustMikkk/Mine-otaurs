extends Sprite2D
var my_id:int
func _ready() -> void:
	my_id=$"..".register_sensor(self)
	#print(my_id)

func _process2(delta: float) -> void:
	var Nposition=position+Vector2(randf()-0.5,randf()-0.5)*delta*200.0
	var p = Vector2i(Nposition/$"..".maze_scale_down)
	if $"..".tab[p.x][p.y]!=1:
		position=Nposition

	
	
func _process(delta: float) -> void:
	var ligth=$"..".get_sensor_data(my_id)
	if ligth>=9:
		self.modulate=Color.ORANGE
		_process2(delta)
	else:
		if ligth>0:
			self.modulate=Color.DARK_SLATE_GRAY
			_process2(delta*0.1)
		else:
			self.modulate=Color.BLACK
