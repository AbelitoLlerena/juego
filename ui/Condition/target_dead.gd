class_name TargetDeadCondition
extends SkillCondition

func check(context: SkillEvaluationContext):
	return context.target.health.is_dead()
