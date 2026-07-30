class_name GridSystem
extends Node

@export var pathfinding: PathfindingService
var occupied := {}

func setup(pathfinding: PathfindingService) -> void:
	self.pathfinding = pathfinding

func register_entity(entity:Entity) -> void:
	occupied[entity.c_position.grid_position] = entity

func move_entity(entity:Being, new_cell:Vector2i) -> void:
	occupied.erase(entity.c_position.grid_position)
	pathfinding.set_position_solid(
		entity.c_position.grid_position,
		false
	)
	entity.c_position.grid_position = new_cell
	occupied[new_cell] = entity
	pathfinding.set_position_solid(
		new_cell,
		true
	)

func is_cell_free(cell:Vector2i) -> bool:
	return !occupied.has(cell)

func get_entity(cell:Vector2i) -> Entity:
	return occupied.get(cell)
