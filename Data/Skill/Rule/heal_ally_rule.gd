class_name HealAllyRule
extends SkillRule

func _init(damage: int) -> void:
	condition = IsAllyCondition.new()
	action = HealAction.new()
	action.amount = damage
