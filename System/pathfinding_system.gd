class_name PathfindingSystem
extends Node

@export var path_service : PathfindingService

func setup(path_service : PathfindingService):
	self.path_service = path_service

func find_path(unit:Player,target:Vector2i):
	return path_service.get_astar_path(
		unit.c_position.grid_position,
		target
	)
