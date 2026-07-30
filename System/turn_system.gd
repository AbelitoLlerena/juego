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
	for key in current_entity.stats.variance.keys():
		var value = current_entity.stats.variance[key]
		match key:
			"health":
				var amount = int(value)
				if amount >= 0:
					HealthSystem.heal(current_entity.health, amount)
				else:
					HealthSystem.apply_damage(current_entity.health, -amount)
			"energy":
				var amount = int(value)
				if amount >= 0:
					HealthSystem.restore_energy(current_entity.energy, amount)
				else:
					HealthSystem.spend_energy(current_entity.energy, -amount)
			"morale":
				current_entity.stats.morale = clamp(current_entity.stats.morale + value, 0.0, 1.0)
			"stress":
				current_entity.stats.stress = clamp(current_entity.stats.stress + value, 0.0, 1.0)
			"hungry":
				current_entity.stats.hungry = clamp(current_entity.stats.hungry + value, 0.0, 1.0)
			"thirst":
				current_entity.stats.thirst = clamp(current_entity.stats.thirst + value, 0.0, 1.0)
			"pain":
				current_entity.stats.pain = clamp(current_entity.stats.pain + value, 0.0, 1.0)
			"fatigue":
				current_entity.stats.fatigue = clamp(current_entity.stats.fatigue + value, 0.0, 1.0)
			_:
				print("Stat desconocido: %s" % key)
