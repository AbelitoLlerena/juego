class_name DamageEnemyRule
extends SkillRule

func _init(damage: int) -> void:
	condition = EnumCondition.new()
	condition.enum_selector = GetRelationSelector.new()

	condition.enum_selector.source_selector = CasterSelector.new()
	condition.enum_selector.target_selector = TargetSelector.new()
	condition.expected = SkillTargetType.SkillTargetFilter.ENEMY

	action = DealDamageAction.new()
	action.amount = damage
