class_name PathfindingSystem
extends Node

@export var path_service : PathfindingService

func setup(path_service : PathfindingService):
	self.path_service = path_service

func find_path(unit,target):
	return path_service.get_astar_path(
		unit.grid_position,
		target
	)
