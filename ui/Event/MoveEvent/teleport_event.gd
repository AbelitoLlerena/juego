class_name TeleportEvent
extends MoveEvent

var destination:Vector2i

func execute() -> void:
	await system.teleport_event(
		entity,
		destination
	)
