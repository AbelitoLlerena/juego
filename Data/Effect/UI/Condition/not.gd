class_name NotCondition
extends EffectCondition

@export var condition : EffectCondition


func check(context : EffectContext) -> bool:
	return not condition.check(context)
