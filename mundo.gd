extends Node2D

@onready var tilemap:TileMapLayer = $Ground

@onready var preview: PathPreview = $Pathpreview
@onready var grid_service:GridService = $Grid
@onready var path_finder:PathFinder = $PathFinder
@onready var obstacle_manager:ObstacleManager = $Obstacles

@onready var player = $Player

const TILE_SIZE := 32
const MAP_SIZE := Vector2i(20,20)

var blocked_cells: Array[Vector2i] = [
	Vector2i(4,2),
	Vector2i(4,3),
	Vector2i(4,4),
	Vector2i(6,5),
	Vector2i(7,5),
	Vector2i(8,5),
	Vector2i(2,7)
]

var last_hover := Vector2i(-1,-1)

func _ready():
	grid_service.setup(tilemap)

	path_finder.setup(MAP_SIZE,Vector2(TILE_SIZE,TILE_SIZE),blocked_cells)

	preview.setup(grid_service)

	obstacle_manager.create_obstacles(blocked_cells,TILE_SIZE)

	player.global_position = grid_service.grid_to_world(Vector2i(0,0))

func _process(delta):
	var mouse_cell = grid_service.world_to_grid(
		get_global_mouse_position()
	)

	if mouse_cell != last_hover:
		last_hover = mouse_cell
		update_preview(mouse_cell)

func update_preview(target:Vector2i):
	var start = grid_service.world_to_grid(
		player.global_position
	)

	var path = path_finder.get_astar_path(start,target)
	preview.update_path(path)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
			player.path.clear()

			for cell in preview.path:
				player.path.append(grid_service.grid_to_world(cell))

			preview.clear()
