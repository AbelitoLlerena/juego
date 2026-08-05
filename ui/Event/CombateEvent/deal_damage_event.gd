class_name DealDamageEvent
extends CombatEvent

var target: Entity
var amount := 0

func execute() -> void:
	await system.deal_damage_event(target,amount)
