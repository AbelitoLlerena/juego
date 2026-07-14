class_name EffectSystem
extends RefCounted

static func add_effect(
	component: EffectComponent,
	definition: EffectDefinition,
	context: EffectContext = null
) -> void:
	
	# Buscar si ya existe
	for effect in component.effects:
		if effect.definition == definition:
			add_stacks(component, effect, 1, context)
			return

	var instance := EffectInstance.new()
	instance.definition = definition
	instance.stacks = 1
	instance.remaining_turns = definition.default_duration

	component.effects.append(instance)

	emit(component, EffectTrigger.Trigger.ON_APPLY, context)


static func remove_effect(
	component: EffectComponent,
	effect: EffectInstance,
	context: EffectContext = null
) -> void:

	emit(component, EffectTrigger.Trigger.ON_REMOVE, context)

	component.effects.erase(effect)


static func add_stacks(
	component: EffectComponent,
	effect: EffectInstance,
	amount: int,
	context: EffectContext = null
) -> void:

	if amount <= 0:
		return

	effect.stacks += amount

	if effect.definition.max_stacks > 0:
		effect.stacks = min(effect.stacks, effect.definition.max_stacks)

	emit(component, EffectTrigger.Trigger.ON_STACK_GAIN, context)


static func remove_stacks(
	component: EffectComponent,
	effect: EffectInstance,
	amount: int,
	context: EffectContext = null
) -> void:

	if amount <= 0:
		return

	effect.stacks -= amount

	emit(component, EffectTrigger.Trigger.ON_STACK_LOSS, context)

	if effect.stacks <= 0:
		remove_effect(component, effect, context)


static func emit(
	component: EffectComponent,
	trigger: EffectTrigger.Trigger,
	context: EffectContext = null
) -> void:

	for effect in component.effects:

		if effect.definition == null:
			continue

		for rule in effect.definition.rules:

			if rule.trigger != trigger:
				continue

			# TODO: Evaluar condiciones

			for action in rule.actions:
				# TODO: ActionSystem.execute(action, effect, context)
				pass
