class_name TurnSystem
extends Node

signal turn_started(entity: Player)
signal turn_finished(entity)

var turn_order = []
var current_index := -1
var current_entity = null

func register(entity):
	turn_order.append(entity)

func start():
	current_index = -1
	next_turn()

func next_turn():
	if turn_order.is_empty():
		return

	current_index += 1
	
	if current_index >= turn_order.size():
		current_index = 0

	current_entity = turn_order[current_index]
	turn_started.emit(current_entity)

func end_turn():
	turn_finished.emit(current_entity)
	next_turn()

func remove(entity):
	var index = turn_order.find(entity)

	if index == -1:
		return

	turn_order.remove_at(index)

	if current_index >= index:
		current_index -= 1
