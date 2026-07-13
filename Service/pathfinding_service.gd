extends Node
class_name PathfindingService

var astar := AStarGrid2D.new()

func setup(
	map_size: Vector2i, 
	tile_size: Vector2, 
	blocked: Array[Obstacle]
):
	astar.region = Rect2i(Vector2i.ZERO, map_size) 
	astar.cell_size = tile_size 
	
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN 
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN 
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER 
	
	astar.update() 
	
	for obs in blocked: 
		astar.set_point_solid(obs.grid_position) 

func get_astar_path(start: Vector2i,target: Vector2i) -> Array[Vector2i]: 
	if not astar.region.has_point(target): 
		return [] 

	if astar.is_point_solid(target): 
		return [] 
	
	return astar.get_id_path(start,target).slice(1)
