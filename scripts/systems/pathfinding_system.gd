class_name PathfindingSystem
extends Node

@export var _path_service : PathfindingService

func setup(path_service : PathfindingService):
	_path_service = path_service

func find_path(from:Vector2i,to:Vector2i) -> Array[Vector2i]:
	var from_solid: bool = _path_service.is_point_solid(from)
	var to_solid: bool = _path_service.is_point_solid(to)

	_path_service.set_point_solid(from, false)
	_path_service.set_point_solid(to, false)

	var path := _path_service.get_astar_path(
		from,
		to
	)

	_path_service.set_point_solid(from, from_solid)
	_path_service.set_point_solid(to, to_solid)

	return path
