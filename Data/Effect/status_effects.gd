class_name StatusEffects
extends RefCounted

static func poison() -> EffectDefinition:
	var effect := EffectDefinition.new()
	effect.id = &"poison"
	effect.display_name = "Veneno"
	effect.description = "Sufre daño por turno."
	effect.max_stacks = 10
	effect.default_duration = 3

	var rule := EffectRule.new()
	rule.trigger = EffectTrigger.Trigger.TURN_END
	rule.conditions = AlwaysCondition.new()

	var damage := DealDamageAction.new()
	damage.amount = 1
	damage.per_stack = true
	rule.actions = [damage]

	effect.rules = [rule]
	return effect

static func burn() -> EffectDefinition:
	var effect := EffectDefinition.new()
	effect.id = &"burn"
	effect.display_name = "Quemadura"
	effect.description = "Arde y sufre daño por turno."
	effect.max_stacks = 5
	effect.default_duration = 3

	var rule := EffectRule.new()
	rule.trigger = EffectTrigger.Trigger.TURN_END
	rule.conditions = AlwaysCondition.new()

	var damage := DealDamageAction.new()
	damage.amount = 2
	damage.per_stack = true
	rule.actions = [damage]

	effect.rules = [rule]
	return effect


static func slowed() -> EffectDefinition:
	var effect := EffectDefinition.new()
	effect.id = &"slowed"
	effect.display_name = "Ralentizado"
	effect.description = "Pierde puntos de movimiento al empezar su turno."
	effect.max_stacks = 1
	effect.default_duration = 2

	var rule := EffectRule.new()
	rule.trigger = EffectTrigger.Trigger.TURN_START
	rule.conditions = AlwaysCondition.new()

	var slow := ModifyMovementAction.new()
	slow.amount = -2
	rule.actions = [slow]

	effect.rules = [rule]
	return effect
