class_name GridSystem
extends Node

@export var _pathfinding: PathfindingService
var occupied := {}
var surfaces := {}

func setup(pathfinding: PathfindingService) -> void:
	_pathfinding = pathfinding

func register_entity(entity:Entity) -> void:
	occupied[entity.c_position.grid_position] = entity
	_pathfinding.set_point_solid(entity.c_position.grid_position)

func move_entity(entity:Being, new_cell:Vector2i) -> void:
	occupied.erase(entity.c_position.grid_position)
	_pathfinding.set_point_solid(
		entity.c_position.grid_position,
		false
	)
	entity.c_position.grid_position = new_cell
	occupied[new_cell] = entity
	_pathfinding.set_point_solid(new_cell)

func is_cell_free(cell:Vector2i) -> bool:
	return !occupied.has(cell)

func get_entity(cell:Vector2i) -> Entity:
	return occupied.get(cell)

func blocks_vision(cell: Vector2i) -> bool:
	var entity := get_entity(cell)
	if entity is Thing and entity.blocks_vision:
		return true
	var surface := get_surface(cell)
	return surface is Surface and surface.blocks_vision

func register_surface(surface: Surface) -> void:
	surfaces[surface.c_position.grid_position] = surface

func unregister_surface(cell: Vector2i) -> void:
	surfaces.erase(cell)

func get_surface(cell: Vector2i) -> Surface:
	return surfaces.get(cell)
