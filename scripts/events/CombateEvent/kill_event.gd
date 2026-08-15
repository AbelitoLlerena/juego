class_name KillEvent
extends CombatEvent

var target: Being

func execute() -> void:
	await system.kill_event(target)
