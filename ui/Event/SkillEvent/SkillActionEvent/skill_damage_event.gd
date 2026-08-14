class_name SkillDamageEvent
extends SkillAttackEvent

var damage: Dictionary[DamageType.Type, float] = {}

func execute() -> void:
	if context == null or context.entity == null or system == null:
		return

	await system.execute_damage(
		_create_attack_context()
	)

func _create_attack_context() -> AttackContext:
	var attack_context := super._create_attack_context()

	attack_context.stats.damage = damage.duplicate()

	return attack_context
