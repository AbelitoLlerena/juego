class_name EffectSystem
extends RefCounted

signal register_event(label: String)

static func add_effect_event(
	entity: Being,
	definition: EffectDefinition,
	duration: int = -1
) -> void:

	_add_effect(
		entity,
		definition,
		duration
	)

static func apply_effect_event(
	entity: Being,
	trigger: EffectTrigger.Trigger,
	context = null
) -> void:

	var component: EffectComponent = entity.effect

	for effect in component.effects:
		if effect.definition.reactions.has(trigger):
			_apply_effect_trigger(
				effect,
				trigger,
				context
			)

static func modify_duration_effect_event(
	entity: Being,
	definition: EffectDefinition,
	amount: int
) -> void:

	var effect := _find_effect(entity.effect, definition)

	if effect == null:
		return

	effect.duration += amount
	_valid_duration(entity, effect)

static func modify_stack_effect_event(
	entity: Being,
	definition: EffectDefinition,
	amount: int
) -> void:

	var effect := _find_effect(entity.effect, definition)

	if effect == null:
		return

	_add_stacks(entity, effect, amount)

static func refresh_effect_event(
	entity: Being,
	definition: EffectDefinition
) -> void:

	var effect := _find_effect(
		entity.effect,
		definition
	)

	if effect == null:
		return

	effect.duration = effect.definition.max_duration
	entity.effect.effects_changed.emit()

static func remove_all_effects_event(
	entity: Being
) -> void:

	var component: EffectComponent = entity.effect

	if component.effects.is_empty():
		return

	for effect in component.effects:
		_remove_effect(entity, effect)

#static func remove_effects_by_type_event(
	#entity: Being,
	#type: EffectDefinition.EffectType
#) -> void:
#
	#var component: EffectComponent = entity.effect
	#var removed := false
#
	#for i in range(component.effects.size() - 1, -1, -1):
		#var effect: EffectInstance = component.effects[i]
#
		##if effect.definition.type != null:
			##continue
#
		#component.effects.remove_at(i)
		#removed = true
#
	#if removed:
		#component.effects_changed.emit()

static func remove_effect_event(
	entity: Being,
	definition: EffectDefinition
) -> void:

	var component: EffectComponent = entity.effect
	var effect := _find_effect(
		component,
		definition
	)

	if effect == null:
		return

	_remove_effect(
		entity,
		effect
	)

static func set_duration_effect_event(
	entity: Being,
	definition: EffectDefinition,
	duration: int
) -> void:

	var effect := _find_effect(
		entity.effect,
		definition
	)

	if effect == null:
		return

	effect.duration = duration
	_valid_duration(entity, effect)

static func end_turn(entity: Being) -> void:
	var component: EffectComponent = entity.effect

	for i in range(component.effects.size() - 1, -1, -1):
		var effect: EffectInstance = component.effects[i]

		if effect.reactions.has(EffectTrigger.Trigger.TURN_END):
			apply_effect_event(entity, EffectTrigger.Trigger.TURN_END, entity)

		effect.duration -= 1

		_valid_duration(entity, effect)

static func transfer_effect_event(
	source: Being,
	target: Being,
	definition: EffectDefinition,
) -> void:

	var source_effect := _find_effect(
		source.effect,
		definition
	)

	if source_effect == null:
		return

	_add_effect(
		target, 
		definition, 
		source_effect.duration
	)

	_remove_effect(
		source,
		source_effect
	)

static func _add_effect(
	entity: Being,
	definition: EffectDefinition,
	duration: int = -1
) -> void:

	var component = entity.effect

	for effect in component.effects:
		if effect.definition == definition:
			_add_stacks(component, effect, 1)

			effect.duration = (
				duration
				if duration > 0
				else definition.max_duration
			)

			component.effects_changed.emit()
			return

	var instance := EffectInstance.new(definition)

	instance.stacks = definition.initial_stacks

	instance.duration = (
		duration
		if duration > 0
		else definition.max_duration
	)

	component.effects.append(instance)

	var context = EffectContext.new()
	context.entity = entity
	context.effect = _find_effect(entity.effect, definition)

	apply_effect_event(
		entity,
		EffectTrigger.Trigger.ON_ADD,
		context
	)

	component.effects_changed.emit()

static func _remove_effect(
	entity: Being,
	effect: EffectInstance
) -> void:

	var component := entity.effect

	if !component.effects.has(effect):
		return

	_remove_all_stat_modifiers(entity.stats, effect)

	var context := EffectContext.new()
	context.effect = effect
	context.entity = entity

	apply_effect_event(
		entity,
		EffectTrigger.Trigger.ON_REMOVE,
		context
	)

	component.effects.erase(effect)
	component.effects_changed.emit()

static func _apply_effect_trigger(
	effect: EffectInstance,
	trigger: EffectTrigger.Trigger,
	context = null
) -> void:
	if context == null:
		return

	effect.reactions[trigger].execute(context)

static func _add_stacks(
	entity: Being,
	effect: EffectInstance,
	amount: int
) -> void:

	var component := entity.effect
	_remove_stat_modifiers(entity.stats, effect)

	effect.stacks += amount
	effect.stacks = min(
		effect.stacks,
		effect.definition.max_stacks
	)

	if effect.stacks <= 0:
		_remove_effect(
			entity,
			effect
		)

	else:
		var trigger := (
			EffectTrigger.Trigger.ON_STACK_GAIN
			if amount >= 0
			else EffectTrigger.Trigger.ON_STACK_LOSS
		)
		var context = EffectContext.new()
		context.entity = entity
		context.effect = effect
		
		apply_effect_event(
			entity,
			trigger,
			context
		)

		_apply_stat_modifiers(entity.stats, effect)
		component.effects_changed.emit()

static func _find_effect(
	component: EffectComponent,
	definition: EffectDefinition
) -> EffectInstance:

	for effect in component.effects:
		if effect.definition == definition:
			return effect

	return null

static func _valid_duration(
	entity: Being,
	effect: EffectInstance
) -> void:

	effect.duration = (
		clamp(effect.duration, 0, effect.definition.max_duration)
		if effect.definition.max_duration > 0
		else min(effect.duration, effect.definition.max_duration)
	)

	if effect.duration <= 0 and effect.duration <= effect.definition.max_duration:
		_remove_effect(
			entity,
			effect
		)
	else:
		entity.effect.effects_changed.emit()

static func _apply_stat_modifiers(
	component:StatsComponent,
	effect: EffectInstance
):

	for stat in effect.definition.stat_modifiers.keys():
		effect.apply_stat_modifier(stat)
		#agregar effect.applied_stat_modifiers[stat] a la stat en el component

static func _remove_all_stat_modifiers(
	component:StatsComponent,
	effect: EffectInstance
):

	_remove_stat_modifiers(component, effect)

	for stat in effect.applied_stat_modifiers.keys():
		if effect.definition.stat_modifiers.has(stat):
			continue
		#quitar effect.applied_stat_modifiers[stat] a la stat en el component

static func _remove_stat_modifiers(
	component:StatsComponent,
	effect: EffectInstance
):

	for stat in effect.definition.stat_modifiers.keys():
		var before = effect.applied_stat_modifiers[stat]
		effect.disapply_stat_modifier(stat)
		var modify_amount = before - effect.applied_stat_modifiers[stat]
		#quitar el modify_amount de la stat en el component
