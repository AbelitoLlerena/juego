class_name ProcessAttackEvent
extends CombatEvent

var context: AttackContext

func execute() -> void:
	await system.process_attack(context)
