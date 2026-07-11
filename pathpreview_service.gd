class_name PathPreviewService
extends Node2D

var grid_service : GridService
var path : Array[Vector2i]

func setup(grid:GridService):
	grid_service = grid

func set_path(new_path:Array[Vector2i]):
	path = new_path
	queue_redraw()

func clear():
	path.clear()
	queue_redraw()

func _draw():
	if grid_service == null:
		return

	for cell in path:
		var pos = grid_service.grid_to_world(cell)
		
		draw_circle(to_local(pos),6,Color.YELLOW)
