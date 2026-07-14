class_name StacksEqualCondition
extends EffectCondition

@export var amount : int

func check(context : EffectContext) -> bool:
	return context.effect_instance.stacks >= amount
