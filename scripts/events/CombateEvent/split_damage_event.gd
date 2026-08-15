class_name SplitDamageEvent
extends CombatEvent

var targets : Array[HealthComponent]
var damage: int

func execute() -> void:
	await system.split_damage_event(targets, damage)
