class_name HealEvent
extends CombatEvent

var target: Being
var amount := 0

func execute() -> void:
	await system.heal_event(target, amount)
