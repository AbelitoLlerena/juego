class_name PathFinder
extends Node

var astar := AStarGrid2D.new()
var blocked_cells: Dictionary = {}

func setup(
	map_size: Vector2i,
	tile_size: Vector2,
	blocked: Dictionary
):
	blocked_cells = blocked

	astar.region = Rect2i(Vector2i.ZERO, map_size)
	astar.cell_size = tile_size

	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN

	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	astar.update()


	for cell in blocked_cells:
		astar.set_point_solid(cell)


func get_astar_path(
	start: Vector2i,
	target: Vector2i
) -> Array[Vector2i]:

	if not astar.region.has_point(target):
		return []

	if blocked_cells.has(target):
		return []

	return astar.get_id_path(start,target)
