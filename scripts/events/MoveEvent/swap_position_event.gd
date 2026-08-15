class_name SwapPositionEvent
extends MoveEvent

var other:Entity

func execute() -> void:
	await system.swap_position_event(
		entity,
		other
	)
