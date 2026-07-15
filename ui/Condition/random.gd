class_name RandomChanceCondition
extends ConditionDefinition

@export_range(0,100)
var chance : float


func check(context) -> bool:
	return randf() * 100 <= chance
