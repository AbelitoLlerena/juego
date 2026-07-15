class_name StackCondition
extends EffectCondition

@export var amount : int

func check(context : EffectContext) -> bool:
	return context.effect_instance.stacks >= amount
