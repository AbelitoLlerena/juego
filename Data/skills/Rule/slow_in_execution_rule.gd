class_name SlowInExecutionRule
extends SkillRule

func _init(execution_name: String) -> void:
	condition = ContainsCondition.new()

	condition.collection_selector = ExecutionTilesSelector.new(execution_name)
	condition.value_selector = TargetTileSelector.new()
	condition.execution_name = execution_name

	action = SkillApplyEffectEvent.new()
	action.effect = StatusEffects.slowed()
