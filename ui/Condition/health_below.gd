class_name HealthBelowCondition
extends EffectCondition

@export_range(0,100)
var percentage : float


func check(context : EffectContext) -> bool:
	var hp_percentage = (
		float(context.owner.health) /
		context.owner.max_health
	) * 100

	return hp_percentage < percentage
