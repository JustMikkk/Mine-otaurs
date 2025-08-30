class_name MapGenerator
extends Node

enum Tile {
	EMPTY,
	WALL,
	OBSIDIAN
}

@export var _map_size: Vector2i = Vector2i(25, 25)
@export var _obsidian_amount: int = 3

var _map: Array[Array]
var _random_bound = 1
var _empty_tiles = 9

@onready var _walls_tile_map: TileMapLayer = $"../Walls-TileMap"
@onready var _empty_tiles_goal = _map_size.x * _map_size.y / 5


func generate_maze() -> void:
	_fill_with_walls()
	_add_obsidian()
	#_map[_map_size.y /2][_map_size.x /2] = Tile.EMPTY
	_add_start_room()
	
	seed(Time.get_ticks_msec())
	var filling_index: int = randi_range(0, 3)
	while (_empty_tiles < _empty_tiles_goal):
		match filling_index:
			0:
				_fill_tiles_bottom_left()
			1:
				_fill_tiles_bottom_right()
			2:
				_fill_tiles_top_left()
			3:
				_fill_tiles_top_right()
		
		#filling_index = randi_range(0, 3)
		
		filling_index = filling_index + 1 if filling_index + 1 != 4 else 0
		
	
	_fill_tiles_top_left()
	_fill_tiles_top_right()
	_fill_tiles_bottom_left()
	_fill_tiles_bottom_right()
	
	_print_map()



func _fill_tiles_top_left() -> void:
	_fill_tiles(0, _map_size.x, 0, _map_size.y, 1, 1)

func _fill_tiles_top_right() -> void:
	_fill_tiles(_map_size.x -1, -1, 0, _map_size.y, -1, 1)

func _fill_tiles_bottom_left() -> void:
	_fill_tiles(0, _map_size.x, _map_size.y -1, -1, 1, -1)

func _fill_tiles_bottom_right() -> void:
	_fill_tiles(_map_size.x -1, -1, _map_size.y, -1, -1, -1)


func _fill_tiles(start_x: int, end_x: int, start_y: int, end_y: int, step_x: int, step_y: int) -> void:
	for y in range(start_y, end_y, step_y):
		for x in range(start_x, end_x, step_x):
			if _can_place_here(x, y):
				_empty_tiles += 1
				_map[y][x] = Tile.EMPTY


func _can_place_here(x: int, y: int) -> bool:
	return (_is_top_left_wall(x, y) and _is_top_right_wall(x, y) and \
	_is_bottom_left_wall(x, y) and _is_bottom_right_wall(x, y)) and \
	(_is_tile_empty(x +1, y) or _is_tile_empty(x, y +1) or \
	_is_tile_empty(x -1, y) or _is_tile_empty(x, y -1)) and \
	_map[y][x] == Tile.WALL and _get_room_chance()


func _get_room_chance() -> bool:
	if (_empty_tiles > _random_bound * 3):
		_random_bound += 1
	
	return randi_range(0, _random_bound) == 1


func _is_top_left_wall(x: int, y: int) -> bool:
	return _is_tile_wall(x -1, y -1) || _is_wall_left(x, y) || _is_wall_up(x, y)

func _is_top_right_wall(x: int, y: int) -> bool:
	return _is_tile_wall(x +1, y -1) || _is_wall_right(x, y) || _is_wall_up(x, y)

func _is_bottom_left_wall(x: int, y: int) -> bool:
	return _is_tile_wall(x -1, y +1) || _is_wall_left(x, y) || _is_wall_down(x, y)

func _is_bottom_right_wall(x: int, y: int) -> bool:
	return _is_tile_wall(x +1, y +1) || _is_wall_right(x, y) || _is_wall_down(x, y)


func _is_wall_up(x: int, y: int) -> bool:
	return _is_tile_wall(x, y -1)

func _is_wall_down(x: int, y: int) -> bool:
	return _is_tile_wall(x, y +1)

func _is_wall_left(x: int, y: int) -> bool:
	return _is_tile_wall(x -1, y)

func _is_wall_right(x: int, y: int) -> bool:
	return _is_tile_wall(x +1, y )


func _is_tile_wall(x: int, y: int) -> bool:
	if x < 0 or x >= _map_size.x: return false
	if y < 0 or y >= _map_size.y: return false
	
	return _map[y][x] == Tile.WALL


func _is_tile_obsidian(x: int, y: int) -> bool:
	return _map[y][x] == Tile.OBSIDIAN

func _is_tile_empty(x: int, y: int) -> bool:
	if x < 0 or x >= _map_size.x: return false
	if y < 0 or y >= _map_size.y: return false
	return _map[y][x] == Tile.EMPTY


func _add_start_room() -> void:
	var starter_tile := Vector2i(_map_size.x / 2 -1, _map_size.y / 2 -1)
	for y in range(3):
		for x in range(3):
			_map[starter_tile.y + y][starter_tile.x + x] = Tile.EMPTY


func _add_obsidian() -> void:
	for y in _map.size():
		for x in _map[0].size():
			if x in range(0, _obsidian_amount) or \
			y in range(0, _obsidian_amount) or \
			x in range(_map[0].size() - _obsidian_amount, _map[0].size()) or \
			y in range(_map.size() - _obsidian_amount, _map.size()):
				_map[y][x] = Tile.OBSIDIAN


func _fill_with_walls() -> void:
	for y in range(_map_size.y):
		_map.append([])
		for x in range(_map_size.x):
			_map[y].append(Tile.WALL)


func _print_map() -> void:
	var color := "white"
	
	for row in _map:
		var result_str := ""
		for tile in row:
			match tile:
				Tile.EMPTY:
					color = "white"
				Tile.WALL:
					color = "orange"
				Tile.OBSIDIAN:
					color = "purple"
			result_str += "[color=" + color + "]# [/color]"
		print_rich(result_str)
		await get_tree().create_timer(0.01).timeout
		
	
