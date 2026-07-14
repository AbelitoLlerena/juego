class_name EnergyBelowCondition
extends EffectCondition

@export var amount : int


func check(context : EffectContext) -> bool:
	return context.owner.energy < amount
