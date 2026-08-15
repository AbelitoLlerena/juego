class_name ComparisonCondition
extends ConditionDefinition

enum Operation {
	EQUAL,
	NOT_EQUAL,
	GREATER,
	GREATER_EQUAL,
	LESS,
	LESS_EQUAL
}

@export var left: ValueSelector
@export var operation: Operation
@export var right: ValueSelector

func check(context) -> bool:
	var a := left.get_value(context)
	var b := right.get_value(context)

	match operation:
		Operation.EQUAL:
			return a == b
		Operation.NOT_EQUAL:
			return a != b
		Operation.GREATER:
			return a > b
		Operation.GREATER_EQUAL:
			return a >= b
		Operation.LESS:
			return a < b
		Operation.LESS_EQUAL:
			return a <= b

	return false
