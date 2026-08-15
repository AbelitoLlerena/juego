class_name RedirectDamageEvent
extends CombatEvent

var target: Entity
var attack : AttackContext

func execute() -> void:
	await system.redirect_damage_event(
		target,
		attack
	)
