class_name SkillAreaPreview
extends Node2D

var grid_service: GridService
var cells: Array[Vector2i] = []
var color := Color(1.0, 0.45, 0.1, 0.9)

func setup(grid: GridService) -> void:
	grid_service = grid
	z_index = 20

func set_cells(
	new_cells: Array[Vector2i],
	new_color: Color = Color(1.0, 0.45, 0.1, 0.9)
) -> void:
	cells = new_cells
	color = new_color
	queue_redraw()

func clear() -> void:
	cells.clear()
	queue_redraw()

func _draw() -> void:
	if grid_service == null:
		return

	var fill := Color(color, color.a * 0.28)
	for cell in cells:
		var center := grid_service.grid_to_world(cell)
		var origin := to_local(center) - Vector2(16, 16)
		var rect := Rect2(origin, Vector2(32, 32))
		draw_rect(rect, fill)
		draw_rect(rect, color, false, 2.0)
