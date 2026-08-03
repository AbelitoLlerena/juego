class_name ProbabilityCondition
extends ConditionDefinition

@export_range(0.0, 100.0)
var chance := 100.0

func check(context) -> bool:
	return randf() * 100.0 <= chance
