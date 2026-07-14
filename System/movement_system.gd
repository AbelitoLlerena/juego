class_name MovementSystem
extends Node

@export var grid_system : GridSystem
@export var grid_service : GridService

signal move_finished()

var is_moving = false
var current_unit: Player

func setup(
	grid_system : GridSystem,
	grid_service : GridService
):
	self.grid_system = grid_system
	self.grid_service = grid_service

func move_unit(unit: Player, path: Array[Vector2i]) -> void:
	var steps := path.duplicate()
	is_moving = true
	current_unit = unit

	for cell in steps:
		if !(is_moving and grid_system.is_cell_free(cell)):
			return

		var from: Vector2i = unit.grid_position
		grid_system.move_entity(unit, cell)
		var target_pos: Vector2 = grid_service.grid_to_world(cell)

		var direction: Vector2i = cell - from
		unit.play_walk(direction)

		var tween := create_tween()
		tween.tween_property(unit, "global_position", target_pos, 0.25)
		await tween.finished

		move_finished.emit()
		await get_tree().create_timer(0.25).timeout

	is_moving = false
	unit.idle()

func stop_move():
	is_moving = false
	if current_unit:
		current_unit.idle()
