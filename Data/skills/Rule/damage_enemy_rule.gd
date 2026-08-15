class_name DamageEnemyRule
extends SkillRule

func _init(damage: Dictionary[DamageType.Type, float]) -> void:
	condition = EnumCondition.new()
	condition.enum_selector = GetRelationSelector.new()

	condition.enum_selector.source_selector = CasterSelector.new()
	condition.enum_selector.target_selector = TargetSelector.new()
	condition.expected = SkillTargetType.SkillTargetFilter.ENEMY

	action = SkillDamageEvent.new()
	action.damage = damage
