extends Node2D

@onready var tilemap = $Ground
@onready var player = $Player
@onready var obstacles = $Obstacles

const TILE_SIZE := 32
const MAP_SIZE := Vector2i(20,20)

var preview_path: Array[Vector2i] = []
var astar := AStarGrid2D.new()

var blocked_cells := {
	Vector2i(4,2):true,
	Vector2i(4,3):true,
	Vector2i(4,4):true,
	Vector2i(6,5):true,
	Vector2i(7,5):true,
	Vector2i(8,5):true,
	Vector2i(2,7):true
}

var last_hovered_cell := Vector2i.ZERO

func _process(delta):
	var hovered = tilemap.local_to_map(tilemap.to_local(get_global_mouse_position()))

	if hovered != last_hovered_cell:
		last_hovered_cell = hovered
		update_preview_path(hovered)

func _draw():
	for cell in preview_path:
		var pos = tilemap.to_global(tilemap.map_to_local(cell))
		draw_circle(to_local(pos), 6, Color.YELLOW)

func update_preview_path(target: Vector2i):
	if !astar.region.has_point(target):
		preview_path.clear()
		queue_redraw()
		return
		
	if blocked_cells.has(target):
		preview_path.clear()
		queue_redraw()
		return

	var start = tilemap.local_to_map(tilemap.to_local(player.global_position))

	preview_path = astar.get_id_path(start, target)

	queue_redraw()
	
func _ready():
	setup_astar()
	draw_obstacles()
	
	player.global_position = tilemap.to_global(
		tilemap.map_to_local(Vector2i(1, 1))
	)
	
func setup_astar():
	astar.region = Rect2i(Vector2i.ZERO, MAP_SIZE)
	astar.cell_size = Vector2(TILE_SIZE, TILE_SIZE)

	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN

	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	astar.update()

	for cell in blocked_cells.keys():
		astar.set_point_solid(cell)

func _unhandled_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		player.path.clear()

		for i in range(1, preview_path.size()):
			player.path.append(
				tilemap.to_global(
					tilemap.map_to_local(preview_path[i])
				)
			)
			
		preview_path.clear()
		queue_redraw()

func draw_obstacles():
	for cell in blocked_cells.keys():
		var rect := ColorRect.new()

		rect.color = Color.DARK_RED
		rect.size = Vector2(TILE_SIZE, TILE_SIZE)

		rect.position = tilemap.map_to_local(cell) - Vector2(TILE_SIZE, TILE_SIZE) / 2
		obstacles.add_child(rect)
