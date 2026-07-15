class_name HasStatusCondition
extends SkillCondition

@export var status_id : StringName

func check(context : SkillContext) -> bool:
	return context.target.has_status(status_id)
