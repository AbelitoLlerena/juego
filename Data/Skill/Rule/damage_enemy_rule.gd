class_name DamageEnemyRule
extends SkillRule

func _init(damage: int) -> void:
	condition = IsEnemyCondition.new()
	action = DealDamageAction.new()
	action.amount = damage
