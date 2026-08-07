class_name EffectSystem
extends RefCounted

static func create_instance(
	definition: EffectDefinition,
	stacks: int = 1
) -> EffectInstance:
	var instance := EffectInstance.new()

	instance.definition = definition
	instance.duration = definition.default_duration
	instance.stacks = stacks

	return instance

static func add_effect(
	component: EffectComponent,
	definition: EffectDefinition,
	stacks := 1,
	duration := -1
) -> void:

	for effect in component.effects:
		if effect.definition == definition:
			add_stacks(effect, stacks)
			return

	var instance := EffectInstance.new()
	instance.definition = definition
	instance.stacks = stacks
	instance.remaining_turns = duration if duration >= 0 else definition.default_duration

	component.effects.append(instance)
	component.effects_changed.emit()


static func remove_effect(
	component: EffectComponent,
	effect: EffectInstance,
) -> void:
	component.effects.erase(effect)
	component.effects_changed.emit()

static func add_stacks(
	effect: EffectInstance,
	amount: int,
) -> void:
	if amount <= 0:
		return

	effect.stacks += amount
	effect.stacks = min(effect.stacks, effect.definition.max_stacks)

static func remove_stacks(
	component: EffectComponent,
	effect: EffectInstance,
	amount: int,
) -> void:
	if amount <= 0:
		return

	effect.stacks -= amount

	if effect.stacks <= 0:
		remove_effect(component, effect)

static func end_turn(entity: Being) -> void:
	var component: EffectComponent = entity.effect

	for effect in component.effects:
		if effect.duration < 0:
			continue

		effect.duration -= 1

		if effect.duration <= 0:
			remove_effect(component,effect)

	component.effects_changed.emit()
