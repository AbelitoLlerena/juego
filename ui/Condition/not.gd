class_name NotCondition
extends ConditionDefinition

@export var condition : ConditionDefinition


func check(context) -> bool:
	return not condition.check(context)
