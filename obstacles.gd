class_name ObstacleManager
extends Node

func create_obstacles(
	cells:Dictionary,
	tile_size:int
):

	for cell in cells:
		var rect := ColorRect.new()

		rect.color = Color.DARK_RED
		rect.size = Vector2(tile_size,tile_size)

		rect.position = (
			Vector2(cell) * tile_size
		)

		add_child(rect)
