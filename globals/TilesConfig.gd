extends Node


const BG_BLOCKING = Vector2i(0, 0)

const WALL_DEFAULT = Vector2(1, 1)
const WALL_OBSIDIAN = Vector2i(0, 6)

const WALL_CORNER_TOP_LEFT = Vector2i(0, 0)
const WALL_CORNER_TOP_RIGHT = Vector2i(4, 0)
const WALL_CORNER_BOTTOM_LEFT = Vector2i(0, 4)
const WALL_CORNER_BOTTOM_RIGHT = Vector2i(4, 4)

const WALLS_EDGE_TOP = [Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)]
const WALLS_EDGE_LEFT = [Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3)]
const WALLS_EDGE_RIGHT = [Vector2i(4, 1), Vector2i(4, 2), Vector2i(4, 3)]
const WALLS_EDGE_BOTTOM = [Vector2i(1, 4), Vector2i(2, 4), Vector2i(3, 4)]

const WALLS_INSIDE = [
	Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1),
	Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2),
	Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3),
]

const WALL_ONE_TOP = Vector2i(6, 2)
const WALL_ONE_LEFT = Vector2i(2, 6)
const WALL_ONE_RIGHT = Vector2i(7, 6)
const WALL_ONE_BOTTOM = Vector2i(6, 7)

const WALLS_UP_DOWN = [Vector2i(6, 3), Vector2i(6, 4), Vector2i(6, 5)]
const WALLS_LEFT_RIGHT = [Vector2i(3, 6), Vector2i(4, 6), Vector2i(5, 6)]

const WALL_CROSSROAD = Vector2i(6, 6)

const WALL_SINGULAR = Vector2i(6, 0)

func get_coresponding_tile(arr: Array[bool]) -> Vector2i:
	match arr:
		[
			 true, 
			true, true, true,
			 true, 		]:
			return WALLS_INSIDE[randi_range(0, 8)]
		[
			 false, 
			false, true, true,
			 true, 		]:
			return WALL_CORNER_TOP_LEFT
		[
			 false, 
			true, true, false,
			 true, 		]:
			return WALL_CORNER_TOP_RIGHT
		[
			 true, 
			false, true, true,
			 false, 		]:
			return WALL_CORNER_BOTTOM_LEFT
		[
			 true, 
			true, true, false,
			 false, 		]:
			return WALL_CORNER_BOTTOM_RIGHT
		[
			 false, 
			true, true, true,
			 true, 		]:
			return WALLS_EDGE_TOP[randi_range(0, 2)]
		[
			 true, 
			false, true, true,
			 true, 		]:
			return WALLS_EDGE_LEFT[randi_range(0, 2)]
		[
			 true, 
			true, true, false,
			 true, 		]:
			return WALLS_EDGE_RIGHT[randi_range(0, 2)]
		[
			 true, 
			true, true, true,
			 false, 		]:
			return WALLS_EDGE_BOTTOM[randi_range(0, 2)]
		[
			 false, 
			false, true, false,
			 true, 		]:
			return WALL_ONE_TOP
		[
			 false, 
			true, true, false,
			 false, 		]:
			return WALL_ONE_RIGHT
		[
			 false, 
			false, true, true,
			 false, 		]:
			return WALL_ONE_LEFT
		[
			 true, 
			false, true, false,
			 false, 		]:
			return WALL_ONE_BOTTOM
		[
			 true, 
			false, true, false,
			 true, 		]:
			return WALLS_UP_DOWN[randi_range(0, 2)]
		[
			 false, 
			true, true, true,
			 false, 		]:
			return WALLS_LEFT_RIGHT[randi_range(0, 2)]
		[
			 true, 
			true, true, true,
			 true, 		]:
			return WALL_CROSSROAD
		[
			 false, 
			false, true, false,
			 false, 		]:
			return WALL_SINGULAR
	return WALL_SINGULAR
