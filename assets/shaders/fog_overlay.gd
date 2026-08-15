class_name FogOverlay
extends Node2D

const TILE_SIZE := 32

var board_size := Vector2i(20, 20)
var lit_tiles: Array[Vector2i] = []
var seen_tiles: Array[Vector2i] = []

const DARK := Color(0.0, 0.0, 0.0, 0.55)
const BLACK := Color(0.0, 0.0, 0.0, 0.9)

func update_vision(_visible: Array[Vector2i], _revealed: Array[Vector2i]) -> void:
	lit_tiles = _visible
	seen_tiles = _revealed
	queue_redraw()

func _draw() -> void:
	var seen := {}
	for tile in seen_tiles:
		seen[tile] = true

	var lit := {}
	for tile in lit_tiles:
		lit[tile] = true

	for x in range(board_size.x):
		for y in range(board_size.y):
			var tile := Vector2i(x, y)
			var rect := Rect2(Vector2(tile) * TILE_SIZE, Vector2(TILE_SIZE, TILE_SIZE))

			if lit.has(tile):
				continue
			elif seen.has(tile):
				draw_rect(rect, DARK, true)
			else:
				draw_rect(rect, BLACK, true)
