class_name GridSystem
extends Node

var occupied := {}

func register_entity(entity:Entity):
	occupied[entity.c_position.grid_position] = entity

func move_entity(entity:Player, new_cell:Vector2i):
	occupied.erase(entity.c_position.grid_position)
	entity.c_position.grid_position = new_cell
	occupied[new_cell] = entity

func is_cell_free(cell:Vector2i):
	return !occupied.has(cell)

func get_entity(cell:Vector2i):
	return occupied.get(cell)
