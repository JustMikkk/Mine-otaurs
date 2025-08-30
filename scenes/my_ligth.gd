extends Sprite2D
@export var li:MyLigth
func _ready() -> void:
	var id=li.register_ligth(self)
