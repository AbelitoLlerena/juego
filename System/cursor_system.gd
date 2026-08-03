class_name CursorSystem
extends  Node

signal cursor_updated(state:CursorState)
signal primary_click()

var state := CursorState.new()
var condition: ConditionDefinition = AlwaysCondition.new()
var invalid_tile:bool = false
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
	if !condition.check(context):
		invalid_tile = true
		cursor_mesage = "Invalid tile"

	cursor_updated.emit(state)

func push_condition(condition: ConditionDefinition) -> void:
	self.condition = condition

func pop_condition() -> void:
	condition = AlwaysCondition.new()

func on_primary_clicked():
	if invalid_tile:
		return
	primary_click.emit()
