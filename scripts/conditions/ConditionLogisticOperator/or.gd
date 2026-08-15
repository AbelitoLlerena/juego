class_name OrCondition
extends ConditionDefinition

@export var conditions : Array[ConditionDefinition]

func check(context) -> bool:
	for condition in conditions:
		if condition.check(context):
			return true

	return false
