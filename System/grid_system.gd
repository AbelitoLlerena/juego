class_name GridSystem
extends Node

var occupied := {}

func register_entity(entity):
	occupied[entity.grid_position] = entity

func move_entity(entity,new_cell):
	occupied.erase(entity.grid_position)
	entity.grid_position = new_cell
	occupied[new_cell] = entity

func is_cell_free(cell):
	return !occupied.has(cell)

func get_entity(cell):
	return occupied.get(cell)
