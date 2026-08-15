class_name SkillDamageEvent
extends SkillAttackEvent

var damage: Dictionary[DamageType.Type, float] = {}

func execute() -> void:
	system.execute_damage(
		_create_attack_context()
	)

func _create_attack_context() -> AttackContext:
	var attack_context := super._create_attack_context()

	attack_context.stats.damage = damage.duplicate()

	return attack_context
