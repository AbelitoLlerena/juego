class_name MovementSystem
extends Node

@export var _grid_system : GridSystem
@export var _grid_service : GridService

signal move_finished()

var is_moving = false

func setup(
	grid_system : GridSystem,
	grid_service : GridService
):
	self._grid_system = grid_system
	self._grid_service = grid_service

func move_unit(unit: Being, path: Array[Vector2i]) -> void:
	var steps := path.duplicate()
	is_moving = true

	for cell in steps:
		if !(is_moving and _grid_system.is_cell_free(cell)):
			is_moving = false
			return

		_grid_system.move_entity(unit, cell)
		unit.on_ground(_grid_system)
		var target_pos: Vector2 = _grid_service.grid_to_world(cell)

		var tween := create_tween()
		tween.tween_property(unit, "global_position", target_pos, 0.25)
		await tween.finished

		move_finished.emit()
		await get_tree().create_timer(0.35).timeout

	is_moving = false


func stop_move():
	is_moving = false
