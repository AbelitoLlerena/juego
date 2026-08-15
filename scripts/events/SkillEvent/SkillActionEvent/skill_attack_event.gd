class_name SkillAttackEvent
extends SkillActionEvent

var precision: float = 0.0
var critical_chance: float = 0.0
var critical_multiplier: float = 0.0
var armor_penetration: float = 0.0
var life_steal: float = 0.0

var effect_chances: Dictionary[EffectDefinition, float] = {}

var context: SkillEvaluationContext
var system: CombatSystem

func execute() -> void:
	await system.execute_attack(
		_create_attack_context()
	)

func _create_attack_context() -> AttackContext:
	var attack_context := AttackContext.new()

	attack_context.attacker = context.caster
	attack_context.target = context.entity

	attack_context.stats.precision = precision
	attack_context.stats.critical_chance = critical_chance
	attack_context.stats.critical_multiplier = critical_multiplier

	attack_context.stats.armor_penetration = armor_penetration
	attack_context.stats.life_steal = life_steal

	attack_context.stats.effect_chances = effect_chances.duplicate()

	return attack_context
