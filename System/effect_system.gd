class_name EffectSystem
extends RefCounted

static func add_effect(
	component: EffectComponent,
	definition: EffectDefinition,
	context: EffectContext = null,
	stacks := 1,
	duration := -1
) -> void:
	
	for effect in component.effects:
		if effect.definition == definition:
			add_stacks(component, effect, stacks, context)
			return

	var instance := EffectInstance.new()
	instance.definition = definition
	instance.stacks = stacks
	instance.remaining_turns = duration if duration >= 0 else definition.default_duration

	component.effects.append(instance)

	component.effects_changed.emit()
	emit(component, EffectTrigger.Trigger.ON_APPLY, context)


static func remove_effect(
	component: EffectComponent,
	effect: EffectInstance,
	context: EffectContext = null
) -> void:

	emit(component, EffectTrigger.Trigger.ON_REMOVE, context)

	component.effects.erase(effect)
	component.effects_changed.emit()


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

	if context == null:
		context = EffectContext.new()

	for effect in component.effects:

		if effect.definition == null:
			continue

		context.effect = effect.definition

		for rule in effect.definition.rules:

			if rule.trigger != trigger:
				continue

			if rule.conditions != null and not rule.conditions.check(context):
				continue

			for action in rule.actions:
				ActionSystem.execute(action, context)


static func process_turn(component: EffectComponent, bearer: Being) -> void:
	var context := EffectContext.new()
	context.bearer = bearer

	emit(component, EffectTrigger.Trigger.TURN_END, context)

	var to_remove: Array[EffectInstance] = []
	for effect in component.effects:
		if effect.remaining_turns < 0:
			continue
		effect.remaining_turns -= 1
		if effect.remaining_turns <= 0:
			to_remove.append(effect)

	for effect in to_remove:
		remove_effect(component, effect, context)

	component.effects_changed.emit()
