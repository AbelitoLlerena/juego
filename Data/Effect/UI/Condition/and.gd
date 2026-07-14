class_name AndCondition
extends EffectCondition

@export var conditions : Array[EffectCondition]


func check(context : EffectContext) -> bool:
	for condition in conditions:
		if not condition.check(context):
			return false

	return true
