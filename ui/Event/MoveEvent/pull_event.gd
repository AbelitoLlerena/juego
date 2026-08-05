class_name PullEvent
extends MoveEvent

var origin: Vector2i
var distance: int

func execute() -> void:
	await system.pull_event(
		entity,
		origin,
		distance
	)
