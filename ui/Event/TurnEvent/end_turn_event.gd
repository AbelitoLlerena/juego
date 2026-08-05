class_name EndTurnEvent
extends TurnEvent

func execute() -> void:
	await system.end_turn()
