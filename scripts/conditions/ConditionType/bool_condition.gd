class_name BoolCondition
extends ConditionDefinition

@export var bool_selector: BoolSelector
@export var expected := true

func check(context) -> bool:
	return bool_selector.get_bool(context) == expected
