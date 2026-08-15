class_name SkillHealEvent
extends SkillActionEvent

@export var healing: float = 0.0
@export var critical_chance: float = 0.0
@export var critical_multiplier: float = 0.0

var context: SkillEvaluationContext
var system: CombatSystem

func execute() -> void:
	await system.execute_healing(
		_create_healing_context()
	)

func _create_healing_context() -> HealContext:
	var heal_context := HealContext.new()

	heal_context.healer = context.caster
	heal_context.target = context.entity

	heal_context.stats.healing = healing
	heal_context.stats.critical_chance = critical_chance
	heal_context.stats.critical_multiplier = critical_multiplier

	return heal_context
