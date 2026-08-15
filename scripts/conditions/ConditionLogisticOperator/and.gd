class_name AndCondition
extends ConditionDefinition

@export var conditions : Array[ConditionDefinition]

func check(context) -> bool:
	for condition in conditions:
		if not condition.check(context):
			return false

	return true
