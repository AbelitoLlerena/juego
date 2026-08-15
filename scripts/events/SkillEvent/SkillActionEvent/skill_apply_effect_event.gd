class_name SkillApplyEffectEvent
extends SkillActionEvent

var effect: EffectDefinition
var chance: float = 1.0

var context: SkillEvaluationContext
var system: EffectSystem

func execute() -> void:
	await system.apply_effect(
		_create_effect_context()
	)

func _create_effect_context() -> EffectContext:
	var apply_context := EffectContext.new()

	apply_context.source = context.entity
	apply_context.effect = EffectInstance.new(effect)

	return apply_context
