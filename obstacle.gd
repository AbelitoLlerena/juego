class_name Obstacle
extends Thing

static func new_at(cell: Vector2i) -> Obstacle:
	var o = Obstacle.new()
	o.c_position.grid_position = cell
	return o
