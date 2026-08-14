class_name FadeAnimationCommand
extends AnimationCommand

var _unit: Node
var _target_alpha: float
var _duration := 0.12

func _init(
	unit: Node,
	target_alpha: float,
	duration := 0.12
) -> void:
	_unit = unit
	_target_alpha = target_alpha
	_duration = duration

func execute(animation_system: AnimationSystem) -> void:
	if _unit == null or not is_instance_valid(_unit):
		return

	var tween := animation_system.create_tween()
	tween.tween_property(
		_unit,
		"modulate:a",
		_target_alpha,
		_duration
	)
	await tween.finished
