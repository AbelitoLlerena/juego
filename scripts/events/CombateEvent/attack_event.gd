class_name AttackEvent
extends CombatEvent

var attacker: Being
var target: Entity

func execute() -> void:
	await system.attack_event(attacker,target)
