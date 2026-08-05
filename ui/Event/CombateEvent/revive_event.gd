class_name ReviveEvent
extends CombatEvent

var target: Being
var health_percent := 0.25

func execute() -> void:
	await system.revive_event(
		target,
		int(target.health.max_health*health_percent)
	)
