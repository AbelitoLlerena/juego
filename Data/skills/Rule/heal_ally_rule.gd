class_name HealAllyRule
extends SkillRule

func _init(heal: int) -> void:
	condition = EnumCondition.new()
	condition.enum_selector = GetRelationSelector.new()

	condition.enum_selector.source_selector = CasterSelector.new()
	condition.enum_selector.target_selector = TargetSelector.new()
	condition.expected = SkillTargetType.SkillTargetFilter.ALLY

	action = SkillHealEvent.new()
	action.healing = heal
