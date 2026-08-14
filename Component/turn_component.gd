class_name TurnComponent
extends Resource

signal update_points(turn: TurnComponent)

enum TypePoint {
	MOVEMENT,
	ACTION,
	INVENTORY
}

@export var initiative:int = 0
@export var action_points:int = 2
@export var max_action_points:int = 2
@export var movement_points:int = 6
@export var max_movement_points:int = 6
@export var inventory_points:int = 1
@export var max_inventory_points:int = 1

func reset_points() -> void:
	action_points = max_action_points
	movement_points = max_movement_points
	inventory_points = max_inventory_points

func restore_point(
	type: TypePoint,
	amount: int = 1
) -> void:
	if type == TypePoint.MOVEMENT:
		movement_points = min(movement_points + amount, max_movement_points)
	if type == TypePoint.ACTION:
		action_points = min(action_points + amount, max_action_points)
	if type == TypePoint.INVENTORY:
		inventory_points = min(inventory_points + amount, max_inventory_points)
	update_points.emit(self)

func consuming_point(
	type: TypePoint,
	amount: int = 1
) -> bool:
	if type == TypePoint.MOVEMENT:
		if movement_points < amount:
			return false
		movement_points -= amount
	if type == TypePoint.ACTION:
		if action_points < amount:
			return false
		action_points -= amount
	if type == TypePoint.INVENTORY:
		if inventory_points < amount:
			return false
		inventory_points -= amount

	update_points.emit(self)
	return true
