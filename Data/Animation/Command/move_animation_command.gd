class_name MoveAnimationCommand
extends AnimationCommand

var _unit: Being
var _world_position: Vector2
var _duration := 0.25


func _init(
	unit: Being,
	world_position: Vector2,
	duration := 0.25
):
	_unit = unit
	_world_position = world_position
	_duration = duration


func execute(animation_system: AnimationSystem) -> void:
	#print("command init")
	var tween := animation_system.create_tween()

	tween.tween_property(
		_unit,
		"global_position",
		_world_position,
		_duration
	)

	await tween.finished
	#print("command end")
