class_name MovementSystem
extends Node

@export var _grid_system: GridSystem
@export var _grid_service: GridService

signal move_finished()

var is_moving := false

func setup(
	grid_system: GridSystem,
	grid_service: GridService
) -> void:
	_grid_system = grid_system
	_grid_service = grid_service

# ------------------------------------------------------------------------
# EVENTS
# ------------------------------------------------------------------------

func follow_path_event(unit: Being, path: Array[Vector2i]) -> void:
	_follow_path(unit, path)

func walk_event(unit: Being, cell: Vector2i) -> void:
	var path: Array[Vector2i] = [cell]
	_follow_path(unit, path)

func teleport_event(unit: Entity, cell: Vector2i) -> void:
	if !_grid_system.is_cell_free(cell):
		return

	_grid_system.move_entity(unit, cell)
	unit.global_position = _grid_service.grid_to_world(cell)

func knockback_event(
	unit: Being,
	direction: Vector2i,
	distance: int
) -> void:
	var destination := _find_last_free_cell(
		unit.c_position.grid_position,
		direction,
		distance
	)

	if destination == unit.position.grid_position:
		return

	await _move_cell(unit, destination)

func pull_event(
	unit: Entity,
	origin: Vector2i,
	distance: int
) -> void:
	var current := unit.c_position.grid_position

	var direction := (origin - current).sign()

	var destination := _find_last_free_cell(
		current,
		direction,
		distance
	)

	if destination == current:
		return

	await _move_cell(unit, destination)

func swap_position_event(
	first: Entity,
	second: Entity
) -> void:
	var first_cell := first.c_position.grid_position
	var second_cell := second.c_position.grid_position

	_grid_system.move_entity(first, second_cell)
	_grid_system.move_entity(second, first_cell)

	first.global_position = _grid_service.grid_to_world(second_cell)
	second.global_position = _grid_service.grid_to_world(first_cell)

func stop_movement_event() -> void:
	is_moving = false


# ------------------------------------------------------------------------
# INTERNAL
# ------------------------------------------------------------------------

func _follow_path(
	unit: Being,
	path: Array[Vector2i]
) -> void:
	var steps := path.duplicate()
	is_moving = true

	for cell in steps:
		if !is_moving:
			break

		if !_grid_system.is_cell_free(cell):
			break

		await _move_cell(unit,cell)

		move_finished.emit()
		await get_tree().create_timer(0.35).timeout

	is_moving = false

func _move_cell(unit: Being, cell: Vector2i):
	_grid_system.move_entity(unit, cell)

	var tween := create_tween()
	tween.tween_property(
		unit,
		"global_position",
		_grid_service.grid_to_world(cell),
		0.25
	)

	await tween.finished

func _find_last_free_cell(
	start: Vector2i,
	direction: Vector2i,
	distance: int
) -> Vector2i:
	var cell := start

	for i in distance:
		var next := cell + direction

		if !_grid_system.is_cell_free(next):
			#apply effect
			break

		cell = next

	return cell
