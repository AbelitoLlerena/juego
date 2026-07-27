class_name CursorSystem
extends  Node

signal cursor_updated(state:CursorState)
signal primary_click()

var state := CursorState.new()
var condition: ConditionDefinition = AlwaysCondition.new()
var invalid_tile:bool = false
var cursor_mesage:String = ""

@onready var grid_service: GridService
@onready var grid_system: GridSystem

func setup(grid_service:GridService, grid_system:GridSystem):
	self.grid_service = grid_service
	self.grid_system = grid_system

func on_mouse_moved(world_position: Vector2):
	state.world_position = world_position
	state.grid_position = grid_service.world_to_grid(world_position)
	state.hovered_entity = grid_system.get_entity(state.grid_position)

	if !condition.check(state):
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
