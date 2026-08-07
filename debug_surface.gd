class_name SurfaceDebugScene
extends Node2D

const TILE_SIZE := 32
const MAP_SIZE := Vector2i(20, 15)
const PANEL_WIDTH := 240

var selected_surface: SurfaceSystem.SurfaceType = SurfaceSystem.SurfaceType.FIRE

var pathfinding_service := PathfindingService.new()
var grid_system := GridSystem.new()
var surface_system := SurfaceSystem.new()

var hover_label: Label

func _ready() -> void:
	pathfinding_service.setup(MAP_SIZE, Vector2i(TILE_SIZE, TILE_SIZE), [])
	grid_system.setup(pathfinding_service)
	surface_system.setup(grid_system)

	surface_system.emit_event.connect(_analice_event_surface)

	_create_ui()
	queue_redraw()


func _create_ui() -> void:
	# Lista de superficies
	var list := ItemList.new()

	list.position = Vector2(MAP_SIZE.x * TILE_SIZE + 8, 8)
	list.size = Vector2(220, 300)
	list.select_mode = ItemList.SELECT_SINGLE

	var names := {
		SurfaceSystem.SurfaceType.FIRE: "Fuego",
		SurfaceSystem.SurfaceType.MUD: "Barro",
		SurfaceSystem.SurfaceType.POISON_CLOUD: "Nube de veneno",
		SurfaceSystem.SurfaceType.POISON_PUDDLE: "Charco de veneno",
		SurfaceSystem.SurfaceType.SMOKE: "Humo",
		SurfaceSystem.SurfaceType.WATER_PUDDLE: "Charco de agua",
		SurfaceSystem.SurfaceType.WATER_VAPOR: "Vapor de agua"
	}

	for type in SurfaceSystem.SurfaceType.values():
		list.add_item(names[type])

	list.select(0)

	list.item_selected.connect(func(index):
		selected_surface = index
	)

	add_child(list)

	# Texto bajo el cursor
	hover_label = Label.new()
	hover_label.text = ""
	hover_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hover_label)

func _analice_event_surface(event: SurfaceEvent):
	if event is CreateSurfaceEvent:
		_create_surface(event.surface)
	elif event is RemoveSurfaceEvent:
		_remove_surface(event.surface)

func _create_surface(surface: SurfaceInstance) -> void:
	add_child(surface)

func _remove_surface(surface: SurfaceInstance) -> void:
	remove_child(surface)


func _draw() -> void:
	for x in MAP_SIZE.x + 1:
		draw_line(
			Vector2(x * TILE_SIZE, 0),
			Vector2(x * TILE_SIZE, MAP_SIZE.y * TILE_SIZE),
			Color.DARK_GRAY
		)

	for y in MAP_SIZE.y + 1:
		draw_line(
			Vector2(0, y * TILE_SIZE),
			Vector2(MAP_SIZE.x * TILE_SIZE, y * TILE_SIZE),
			Color.DARK_GRAY
		)


func _process(_delta: float) -> void:
	var mouse := get_local_mouse_position()

	hover_label.position = mouse + Vector2(16, 16)

	var cell := _mouse_to_cell(mouse)

	if cell == Vector2i(-1, -1):
		hover_label.text = ""
		return

	var surface: SurfaceInstance = grid_system.get_surface(cell)

	if surface != null:
		hover_label.text = surface.definition.surface_name
	else:
		hover_label.text = ""


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		var cell := _mouse_to_cell(event.position)

		if cell == Vector2i(-1, -1):
			return
		print("create clic: ",selected_surface)

		surface_system.create(
			SurfaceSystem.SURFACE_MAP[selected_surface],
			cell
		)


func _mouse_to_cell(mouse_position: Vector2) -> Vector2i:
	var cell := Vector2i(mouse_position / TILE_SIZE)

	if cell.x < 0 \
	or cell.y < 0 \
	or cell.x >= MAP_SIZE.x \
	or cell.y >= MAP_SIZE.y:
		return Vector2i(-1, -1)

	return cell
