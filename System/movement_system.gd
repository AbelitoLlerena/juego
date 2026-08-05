class_name MovementSystem
extends Node

@export var _grid_system: GridSystem
@export var _grid_service: GridService
@export var _animation_system: AnimationSystem

signal move_finished()

var is_moving := false

func setup(
	grid_system: GridSystem,
	grid_service: GridService,
	animation_system: AnimationSystem
) -> void:
	_grid_system = grid_system
	_grid_service = grid_service
	_animation_system = animation_system
# ------------------------------------------------------------------------
# EVENTS
# ------------------------------------------------------------------------

func follow_path_event(unit: Being, path: Array[Vector2i]) -> void:
	is_moving = true
	await _follow_path(unit, path)
	is_moving = false

func walk_event(unit: Being, cell: Vector2i) -> void:
	is_moving = true
	print("starting walk")
	if unit.turn.consuming_point(TurnComponent.TypePoint.MOVEMENT):
		await _move_one_cell(unit,cell)
	print("end walk")
	is_moving = false

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

	await _move_one_cell(unit, destination)

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

	await _move_one_cell(unit, destination)

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

	for cell in steps:
		if not (is_moving and \
		_grid_system.is_cell_free(cell) and \
		unit.turn.consuming_point(TurnComponent.TypePoint.MOVEMENT)):
			break

		await _move_one_cell(unit,cell)

func _move_one_cell(unit: Being, cell: Vector2i):
	print("move start")
	_grid_system.move_entity(unit, cell)

	var sequence := AnimationSequence.new()

	sequence.add_batch(
		MoveAnimationBatch.new(
			unit,
			_grid_service.grid_to_world(cell)
		)
	)

	await _animation_system.play(sequence)

	move_finished.emit()
	await get_tree().create_timer(0.35).timeout
	print("move end")

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
