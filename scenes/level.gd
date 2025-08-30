extends Node2D


const WALLS_TILESET = preload("res://tilesets/walls.tres")

var _source_id: int = 999

@onready var _walls_tile_map: TileMapLayer = $"Walls-TileMap"
@onready var _map_generator: MapGenerator = $MapGenerator

@onready var _player_1: Player = $P1
@onready var _player_2: Player = $P2


func _ready() -> void:
	_player_1.break_wall.connect(_on_break_wall)
	_player_2.break_wall.connect(_on_break_wall)
	
	_map_generator.generate_maze()
	_player_1.global_position = _map_generator.map_size / 2 * 128
	_player_2.global_position = _map_generator.map_size / 2 * 128 + Vector2i(128, 0)
	$SavablePerson.global_position = _map_generator.map_size / 2 * 128

func _on_break_wall(pos: Vector2i) -> void:
	if _map_generator.mine_tile(_walls_tile_map.local_to_map(pos)):
		print("min")
	
	
	
	#_walls_tile_map.erase_cell(_walls_tile_map.local_to_map(pos))
