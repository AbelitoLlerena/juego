class_name PathfindingService
extends Node

var _astar := AStarGrid2D.new()

func setup(
	map_size: Vector2i, 
	tile_size: Vector2, 
	blocked: Array[Obstacle]
):
	_astar.region = Rect2i(Vector2i.ZERO, map_size) 
	_astar.cell_size = tile_size
	
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN 
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN 
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER 
	
	_astar.update() 
	
	for obs in blocked: 
		_astar.set_point_solid(obs.c_position.grid_position)

func set_point_solid(point: Vector2i, solid: bool = true) -> void:
	if not _astar.region.has_point(point): 
		return
	_astar.set_point_solid(point, solid)

func is_point_solid(point: Vector2i) -> bool:
	if not _astar.region.has_point(point): 
		return true
	return _astar.is_point_solid(point)

func get_astar_path(start: Vector2i,target: Vector2i) -> Array[Vector2i]: 
	if not _astar.region.has_point(target): 
		return []

	return _astar.get_id_path(start,target).slice(1)
