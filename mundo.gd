extends Node2D

@onready var tilemap = $Ground
@onready var player = $Player
@onready var obstacles = $Obstacles

const TILE_SIZE := 32
const MAP_SIZE := Vector2i(20,20)

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
		var start = tilemap.local_to_map(tilemap.to_local(player.global_position))
		var end = tilemap.local_to_map(tilemap.to_local(get_global_mouse_position()))

		if blocked_cells.has(end):
			return
			
		print("START: ", start)
		print("END: ", end)

		var id_path = astar.get_id_path(start, end)

		player.path.clear()

		for cell in id_path:
			var world = tilemap.to_global(tilemap.map_to_local(cell))
			player.path.append(world)


func draw_obstacles():
	for cell in blocked_cells.keys():
		var rect := ColorRect.new()

		rect.color = Color.DARK_RED
		rect.size = Vector2(TILE_SIZE, TILE_SIZE)

		rect.position = tilemap.map_to_local(cell) - Vector2(TILE_SIZE, TILE_SIZE) / 2
		obstacles.add_child(rect)
