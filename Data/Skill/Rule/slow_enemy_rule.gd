class_name SlowEnemyRule
extends SkillRule

func _init() -> void:
	condition = EnumCondition.new()
	condition.enum_selector = GetRelationSelector.new()

	condition.enum_selector.source_selector = CasterSelector.new()
	condition.enum_selector.target_selector = TargetSelector.new()
	condition.expected = SkillTargetType.SkillTargetFilter.ENEMY

	action = SkillApplyEffectEvent.new()
	action.effect = StatusEffects.slowed()
