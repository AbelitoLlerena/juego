class_name SkillApplyEffectEvent
extends SkillActionEvent

var effect: EffectDefinition
var chance: float = 1.0

var context: SkillEvaluationContext
var system: EffectSystem

func execute() -> void:
	if context == null or context.entity is not Being:
		return
	if randf() > chance:
		return

	EffectSystem.add_effect_event(context.entity, effect)
