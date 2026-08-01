class_name IsEnemyCondition
extends SkillCondition

func  check(context: SkillEvaluationContext) -> bool:
	if context.entity is not Being:
		return false

	return FactionSystem.get_relation(
		context.caster.faction,
		context.entity.faction
	) == SkillTargetType.SkillTargetFilter.ENEMY
