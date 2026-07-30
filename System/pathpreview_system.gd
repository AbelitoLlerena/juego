class_name PathPreviewSystem
extends Node

@export var _pathfinding_system : PathfindingSystem
@export var _grid_system : GridSystem
@export var _preview_service : PathPreviewService

func setup(
	pathfinding_system : PathfindingSystem,
	grid_system : GridSystem,
	preview_service : PathPreviewService
):
	_preview_service = preview_service
	_grid_system = grid_system
	_pathfinding_system = pathfinding_system

func get_preview():
	return _preview_service.path
	
func update_preview(unit: Player,target_cell: Vector2i) -> void:
	if _grid_system.get_entity(target_cell) is Obstacle:
		_preview_service.set_path([])

	var path = _pathfinding_system.find_path(
		unit.c_position.grid_position,
		target_cell
	)

	if _grid_system.get_entity(target_cell) is Entity:
		path = path.slice(0, path.size() - 1)

	else:
		_preview_service.set_path(path)

func clear():
	_preview_service.clear()
