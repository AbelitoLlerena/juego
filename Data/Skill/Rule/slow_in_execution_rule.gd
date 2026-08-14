class_name SlowInExecutionRule
extends SkillRule

func _init(execution_name: String) -> void:
	condition = ContainsCondition.new()

	condition.collection_selector = ExecutionTilesSelector.new(execution_name)
	condition.value_selector = TargetTileSelector.new()

	action = SkillApplyEffectEvent.new()
	action.effect = StatusEffects.slowed()
