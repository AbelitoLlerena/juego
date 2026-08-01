class_name TurnSystem
extends Node

signal turn_started(entity: Player)
signal turn_finished(entity)

var turn_order: Array[Being] = []
var current_index := -1
var current_entity: Being = null

func register(entity: Being):
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
	start_turn()

func start_turn() -> void:
	current_entity.turn.reset_points()
	turn_started.emit(current_entity)

func end_turn():
	HealthSystem.process_turn(current_entity)
	_apply_variance()
	turn_finished.emit(current_entity)
	next_turn()

func remove(entity):
	var index = turn_order.find(entity)

	if index == -1:
		return

	turn_order.remove_at(index)

	if current_index >= index:
		current_index -= 1

func _apply_variance() -> void:
	var stats := current_entity.stats

	if stats.var_health != 0:
		var amount := int(stats.var_health)
		if amount >= 0:
			HealthSystem.heal(current_entity.health, amount)
		else:
			HealthSystem.apply_damage(current_entity.health, -amount)

	if stats.var_energy != 0:
		var amount := int(stats.var_energy)
		if amount >= 0:
			HealthSystem.restore_energy(current_entity.energy, amount)
		else:
			HealthSystem.spend_energy(current_entity.energy, -amount)

	stats.morale = clamp(stats.morale + stats.var_morale, 0.0, 1.0)
	stats.stress = clamp(stats.stress + stats.var_stress, 0.0, 1.0)
	stats.hungry = clamp(stats.hungry + stats.var_hungry, 0.0, 1.0)
	stats.thirst = clamp(stats.thirst + stats.var_thirst, 0.0, 1.0)
	stats.pain = clamp(stats.pain + stats.var_pain, 0.0, 1.0)
	stats.fatigue = clamp(stats.fatigue + stats.var_fatigue, 0.0, 1.0)
