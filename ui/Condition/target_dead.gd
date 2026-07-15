class_name TargetDeadCondition
extends SkillCondition

func chek(context: SkillContext):
	return context.target.health.is_dead()
