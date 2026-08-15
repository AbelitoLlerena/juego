class_name KnockbackEvent
extends MoveEvent

var direction:Vector2
var distance:int = 1

func execute() -> void:
	await system.knockback_event(
		entity,
		direction,
		distance
	)
