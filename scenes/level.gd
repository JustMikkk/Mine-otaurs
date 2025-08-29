extends Node2D


const WALLS_TILESET = preload("res://tilesets/walls.tres")

@export var ts: TileSetSource


var _source_id: int = 999


@onready var _walls_tile_map: TileMapLayer = $"Walls-TileMap"


func _ready() -> void:
	$PlayerWithPick.break_wall.connect(_on_break_wall)
	


func _on_break_wall(pos: Vector2i) -> void:
	_walls_tile_map.set_cell(pos, -1, Vector2i(5, 0))
