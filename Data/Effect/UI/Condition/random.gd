class_name RandomChanceCondition
extends EffectCondition

@export_range(0,100)
var chance : float


func check(context : EffectContext) -> bool:
	return randf() * 100 <= chance
