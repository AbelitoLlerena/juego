class_name BetweenCondition
extends ConditionDefinition

@export var selector: ValueSelector
@export var min_value: ValueSelector
@export var max_value: ValueSelector
@export var inclusive := true

func check(context) -> bool:
	var value := selector.get_value(context)
	var min := min_value.get_value(context)
	var max := max_value.get_value(context)

	if inclusive:
		return value >= min and value <= max

	return value > min and value < max
