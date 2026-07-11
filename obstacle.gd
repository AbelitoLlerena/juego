# obstacle.gd
class_name Obstacle
extends Node2D

var grid_position: Vector2i

static func new_at(cell: Vector2i) -> Obstacle:
	var o = Obstacle.new()
	o.grid_position = cell
	return o
