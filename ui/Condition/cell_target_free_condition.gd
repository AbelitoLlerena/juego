class_name CellTargetFreeCondition
extends SkillCondition

func  check(context: SkillEvaluationContext) -> bool:
	return context.entity == null
