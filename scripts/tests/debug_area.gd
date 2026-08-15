extends Node2D

const TILE_SIZE := 32

enum Shape {
	TARGET,
	CIRCLE,
	LINE,
	CONE
}

@export var shape: Shape = Shape.LINE
@export var origin := Vector2i(10, 10)
@export var target := Vector2i(16, 12)

@export var radius := 7
@export var length := 9
@export var width := 1
@export var angle := 90.0

func _ready():
	queue_redraw()

func _process(_delta: float) -> void:
	var mouse := get_local_mouse_position()
	var new_target := Vector2i(
		floor(mouse.x / TILE_SIZE),
		floor(mouse.y / TILE_SIZE)
	)

	if new_target != target:
		target = new_target
		queue_redraw()

# Devuelve un array de segmentos, cada segmento es un PackedVector2Array con dos puntos
func get_area_borders(cells: Array[Vector2i]) -> Array[PackedVector2Array]:
	var cell_set := {}
	for c in cells:
		cell_set[c] = true

	var borders: Array[PackedVector2Array] = []

	for cell in cells:
		var world_pos := Vector2(cell) * TILE_SIZE
		var corners := [
			world_pos,
			world_pos + Vector2(TILE_SIZE, 0),
			world_pos + Vector2(TILE_SIZE, TILE_SIZE),
			world_pos + Vector2(0, TILE_SIZE)
		]

		if !cell_set.has(cell + Vector2i.LEFT):
			borders.append(PackedVector2Array([corners[0], corners[3]]))
		if !cell_set.has(cell + Vector2i.RIGHT):
			borders.append(PackedVector2Array([corners[1], corners[2]]))
		if !cell_set.has(cell + Vector2i.UP):
			borders.append(PackedVector2Array([corners[0], corners[1]]))
		if !cell_set.has(cell + Vector2i.DOWN):
			borders.append(PackedVector2Array([corners[3], corners[2]]))

	return borders

func draw_area_borders(cells: Array[Vector2i], color: Color = Color.RED, width: float = 2.0) -> void:
	var borders := get_area_borders(cells)
	for segment in borders:
		var a: Vector2 = segment[0]
		var b: Vector2 = segment[1]
		draw_line(a, b, color, width)


func _draw():
	var tiles: Array[Vector2i] = []

	match shape:
		Shape.TARGET:
			tiles = AreaService.target(origin)
		Shape.CIRCLE:
			tiles = AreaService.circle(target, radius)
		Shape.LINE:
			tiles = AreaService.line(origin, target, length, width)
		Shape.CONE:
			tiles = AreaService.cone(origin, target, length, angle)

	# Dibujar relleno de casillas
	for tile in tiles:
		var rect := Rect2(Vector2(tile) * TILE_SIZE, Vector2(TILE_SIZE, TILE_SIZE))
		draw_rect(rect, Color(0.2, 0.8, 1.0, 0.45), true)

	# Dibujar bordes externos del área
	draw_area_borders(tiles, Color.CYAN, 3.0)

	# Dibujar origen
	draw_rect(Rect2(Vector2(origin) * TILE_SIZE, Vector2(TILE_SIZE, TILE_SIZE)), Color.RED, true)

	# Dibujar target
	draw_rect(Rect2(Vector2(target) * TILE_SIZE, Vector2(TILE_SIZE, TILE_SIZE)), Color.GREEN, true)
