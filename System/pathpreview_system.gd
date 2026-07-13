class_name PathPreviewSystem
extends Node

@export var pathfinding_system : PathfindingSystem
@export var preview_service : PathPreviewService

func setup(
	pathfinding_system : PathfindingSystem,
	preview_service : PathPreviewService
):
	self.preview_service = preview_service
	self.pathfinding_system = pathfinding_system

func get_preview():
	return preview_service.path
	
func update_preview(unit,target_cell):
	var path = pathfinding_system.find_path(unit,target_cell)
	preview_service.set_path(path)

func clear():
	preview_service.clear()
