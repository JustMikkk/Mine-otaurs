extends Node2D


const WALLS_TILESET = preload("res://tilesets/walls.tres")

var _source_id: int = 999

@onready var _walls_tile_map: TileMapLayer = $"Walls-TileMap"
@onready var _map_generator: MapGenerator = $MapGenerator


func _ready() -> void:
	$P1.break_wall.connect(_on_break_wall)
	$P2.break_wall.connect(_on_break_wall)
	
	_map_generator.generate_maze()

func _on_break_wall(pos: Vector2i) -> void:
	if _walls_tile_map.get_cell_atlas_coords(_walls_tile_map.local_to_map(pos)) == TilesConfig.WALL_OBSIDIAN: 
		return
	
	_walls_tile_map.set_cell(_walls_tile_map.local_to_map(pos), 1, TilesConfig.WALL_BLANK)
