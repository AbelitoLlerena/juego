extends Node2D

const TILE_SIZE := 32

enum Shape {
	TARGET,
	CIRCLE,
	LINE,
	CONE
}

@export var shape: Shape = Shape.CONE

@export var origin := Vector2i(10, 10)
@export var target := Vector2i(16, 12)

@export var radius := 6
@export var length := 8
@export var width := 1
@export var angle := 45.0

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

func _draw():
	var tiles: Array[Vector2i] = []

	match shape:
		Shape.TARGET:
			tiles = AreaService._target(origin)

		Shape.CIRCLE:
			tiles = AreaService._circle(target, radius)

		Shape.LINE:
			tiles = AreaService._line(origin, target, length, width)

		Shape.CONE:
			tiles = AreaService._cone(origin, target, length, angle)

	# Dibujar las casillas
	for tile in tiles:
		var rect := Rect2(tile * TILE_SIZE, Vector2(TILE_SIZE, TILE_SIZE))
		draw_rect(rect, Color(0.2, 0.8, 1.0, 0.45), true)
		draw_rect(rect, Color.CYAN, false)

	# Dibujar origen
	draw_rect(
		Rect2(origin * TILE_SIZE, Vector2(TILE_SIZE, TILE_SIZE)),
		Color.RED,
		true
	)

	# Dibujar target
	draw_rect(
		Rect2(target * TILE_SIZE, Vector2(TILE_SIZE, TILE_SIZE)),
		Color.GREEN,
		true
	)
