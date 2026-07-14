class_name HasStatusCondition
extends EffectCondition

@export var status_id : StringName

func check(context : EffectContext) -> bool:
	return context.owner.has_status(status_id)
