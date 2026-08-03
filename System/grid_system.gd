class_name GridSystem
extends Node

@export var _pathfinding: PathfindingService
var occupied := {}

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
	return entity is Thing and entity.blocks_vision
