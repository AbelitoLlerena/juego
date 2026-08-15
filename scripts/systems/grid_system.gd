class_name GridSystem
extends Node

signal entity_enter_surface(entity: Being, surface: SurfaceInstance)
signal entity_out_surface(entity: Being, surface: SurfaceInstance)

@export var _pathfinding: PathfindingService
var occupied := {}
var surfaces := {}

func setup(pathfinding: PathfindingService) -> void:
	_pathfinding = pathfinding

func register_entity(entity:Entity) -> void:
	occupied[entity.c_position.grid_position] = entity
	_pathfinding.set_point_solid(entity.c_position.grid_position)

func move_entity(entity:Being, new_cell:Vector2i) -> void:
	_entity_in_surface(entity,new_cell)
	occupied.erase(entity.c_position.grid_position)
	_pathfinding.set_point_solid(
		entity.c_position.grid_position,
		false
	)
	entity.c_position.grid_position = new_cell
	occupied[new_cell] = entity
	_pathfinding.set_point_solid(new_cell)

func _entity_in_surface(entity:Being, to: Vector2i)-> void:
	var surface_from := get_surface(entity.c_position.grid_position)
	var surface_to := get_surface(to)

	if surface_from is SurfaceInstance and surface_to is SurfaceInstance:
		if surface_from != surface_to: 
			entity_out_surface.emit(entity,surface_from)
			entity_enter_surface.emit(entity,surface_to)
	elif surface_from is SurfaceInstance and surface_to == null:
		entity_out_surface.emit(entity,surface_from)
	elif surface_from == null and surface_to is SurfaceInstance:
		entity_enter_surface.emit(entity,surface_to)

func unregister_entity(entity:Entity) -> void:
	occupied.erase(entity.c_position.grid_position)
	_pathfinding.set_point_solid(
		entity.c_position.grid_position,
		false
	)

func is_cell_free(cell:Vector2i) -> bool:
	return !occupied.has(cell)

func get_entity(cell:Vector2i) -> Entity:
	return occupied.get(cell)

func blocks_vision(cell: Vector2i) -> bool:
	var entity := get_entity(cell)
	if entity is Thing and entity.blocks_vision:
		return true
	var surface := get_surface(cell)
	return surface is SurfaceInstance and surface.blocks_vision

func register_surface(surface: SurfaceInstance) -> void:
	surfaces[surface.grid_position] = surface

func unregister_surface(cell: Vector2i) -> void:
	surfaces.erase(cell)

func get_surface(cell: Vector2i) -> SurfaceInstance:
	return surfaces.get(cell)
