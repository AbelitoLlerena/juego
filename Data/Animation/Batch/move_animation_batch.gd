class_name MoveAnimationBatch
extends AnimationBatch

func _init(
	unit: Being,
	world_position: Vector2,
	duration := 0.25
):
	add(
		MoveAnimationCommand.new(
			unit,
			world_position,
			duration
		)
	)
