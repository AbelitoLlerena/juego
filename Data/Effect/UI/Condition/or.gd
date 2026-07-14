class_name OrCondition
extends EffectCondition

@export var conditions : Array[EffectCondition]


func check(context : EffectContext) -> bool:

	for condition in conditions:
		if condition.check(context):
			return true

	return false
