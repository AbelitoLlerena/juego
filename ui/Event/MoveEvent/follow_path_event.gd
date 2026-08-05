class_name FollowPathEvent
extends MoveEvent

var path:Array[Vector2i]

func execute() -> void:
	await system.follow_path_event(
		entity,
		path
	)
