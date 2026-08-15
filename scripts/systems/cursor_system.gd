class_name CursorSystem
extends  Node

signal cursor_updated(state:CursorState)
signal primary_click(state:CursorState)

var state := CursorState.new()
var condition: ConditionDefinition = AlwaysCondition.new() #CellFreeCondition.new()
var cursor_mesage:String = ""

@onready var _grid_service: GridService
@onready var _grid_system: GridSystem
@onready var _player: Player

func setup(grid_service:GridService, grid_system:GridSystem, player:Player):
	_grid_service = grid_service
	_grid_system = grid_system
	_player = player

func on_mouse_moved(world_position: Vector2):
	state.world_position = world_position
	state.grid_position = _grid_service.world_to_grid(world_position)
	state.hovered_entity = _grid_system.get_entity(state.grid_position)

	var context = CursorContext.new()
	context.player = _player
	context.cursor = state
	if condition.check(context):
		state.is_valid = true
		cursor_updated.emit(state)
	else:
		state.is_valid = false
		cursor_mesage = "Invalid tile"
		cursor_updated.emit(state)

func push_condition(condition: ConditionDefinition) -> void:
	self.condition = condition

func pop_condition() -> void:
	condition = AlwaysCondition.new() #CellFreeCondition.new()

func on_primary_clicked():
	if !state.is_valid:
		return
	primary_click.emit(state)

func get_area_borders(cells: Array[Vector2i]) -> Array[PackedVector2Array]:
	var cell_set := {}
	for c in cells:
		cell_set[c] = true

	var borders: Array[PackedVector2Array] = []

	for cell in cells:
		var world_pos := _grid_service.grid_to_world(cell)
		var size := 32
		var corners := [
			world_pos,
			world_pos + Vector2(size, 0),
			world_pos + Vector2(size,size),
			world_pos + Vector2(0, size)
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
