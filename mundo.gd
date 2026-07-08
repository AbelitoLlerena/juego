extends Node2D

@onready var tilemap = $Ground
@onready var player = $Player
@onready var obstacles = $Obstacles

const TILE_SIZE := 32

var blocked_cells := {
	Vector2i(4, 2): true,
	Vector2i(4, 3): true,
	Vector2i(4, 4): true,
	Vector2i(6, 5): true,
	Vector2i(7, 5): true,
	Vector2i(8, 5): true,
	Vector2i(2, 7): true
}

func _ready():
	draw_obstacles()

func draw_obstacles():
	for cell in blocked_cells.keys():
		var rect := ColorRect.new()
		rect.color = Color.DARK_RED

		rect.size = Vector2(TILE_SIZE, TILE_SIZE)

		# Esquina superior izquierda del tile
		rect.position = tilemap.map_to_local(cell)

		obstacles.add_child(rect)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			var mouse_pos = get_global_mouse_position()

			# Coordenadas del mosaico
			var cell = tilemap.local_to_map(tilemap.to_local(mouse_pos))

			# Centro del mosaico
			var world_pos = tilemap.to_global(tilemap.map_to_local(cell))

			player.target_position = world_pos
			player.moving = true
