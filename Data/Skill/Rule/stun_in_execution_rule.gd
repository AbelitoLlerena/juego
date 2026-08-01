class_name StunInExecutionRule
extends SkillRule

func _init(execution_name: String) -> void:
	condition = TargetInExecutionCondition.new()
	action = StunAction.new()
	condition.execution_name = execution_name
