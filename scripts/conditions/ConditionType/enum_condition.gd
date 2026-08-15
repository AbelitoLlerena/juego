class_name EnumCondition
extends ConditionDefinition

@export var enum_selector: EnumSelector
@export var expected: int

func check(context) -> bool:
	return enum_selector.get_enum(context) == expected
