class_name StatusEffects
extends RefCounted

static func poison() -> EffectDefinition:
	var effect := EffectDefinition.new()
	effect.effect_name = "Veneno"
	effect.description = "Sufre daño por turno."
	effect.max_stacks = 10
	effect.max_duration = 3
	effect.initial_stacks = 1

	var end_reaction := ApplyDamageEffectReaction.new()
	var gain_stack_reaction := ModifyApplyDamageEffectReaction.new()
	var loss_stack_reaction := ModifyApplyDamageEffectReaction.new()

	end_reaction.damage = 1
	gain_stack_reaction.amount = 1
	loss_stack_reaction.amount = -1

	effect.reactions[EffectTrigger.Trigger.TURN_END] = end_reaction
	effect.reactions[EffectTrigger.Trigger.ON_STACK_GAIN] = gain_stack_reaction
	effect.reactions[EffectTrigger.Trigger.ON_STACK_LOSS] = loss_stack_reaction

	return effect

static func burn() -> EffectDefinition:
	var effect := EffectDefinition.new()
	effect.effect_name = "Quemadura"
	effect.description = "Arde y sufre daño por turno."
	effect.max_stacks = 5
	effect.max_duration = 3
	effect.initial_stacks = 1

	var end_reaction := ApplyDamageEffectReaction.new()
	var gain_stack_reaction := ModifyApplyDamageEffectReaction.new()
	var loss_stack_reaction := ModifyApplyDamageEffectReaction.new()

	end_reaction.damage = 2
	gain_stack_reaction.amount = 2
	loss_stack_reaction.amount = -2

	effect.reactions[EffectTrigger.Trigger.TURN_END] = end_reaction
	effect.reactions[EffectTrigger.Trigger.ON_STACK_GAIN] = gain_stack_reaction
	effect.reactions[EffectTrigger.Trigger.ON_STACK_LOSS] = loss_stack_reaction

	return effect


static func slowed() -> EffectDefinition:
	var effect := EffectDefinition.new()
	effect.effect_name = "Ralentizado"
	effect.description = "Pierde puntos de movimiento al empezar su turno."
	effect.max_stacks = 1
	effect.max_duration = 2
	effect.initial_stacks = 1

	var slow := ModifyTurnPointsEffectReaction.new()
	slow.amount = -2

	effect.reactions[EffectTrigger.Trigger.TURN_START] = slow

	return effect
