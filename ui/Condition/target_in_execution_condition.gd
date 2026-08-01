class_name TargetInExecutionCondition
extends SkillCondition

var execution_name: String

func  check(context: SkillEvaluationContext) -> bool:
	return context.tile in context.executions[execution_name].tiles
