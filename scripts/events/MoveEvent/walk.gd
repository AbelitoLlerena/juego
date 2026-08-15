class_name WalkEvent
extends MoveEvent

var destination: Vector2i

func execute() -> void:
	await system.walk_event(entity,destination)
