class_name EffectInstance
extends Resource

var definition: EffectDefinition

var duration: int
var stacks: int

var applied_stat_modifiers: Dictionary[StringName, float]
var reactions: Dictionary[EffectTrigger.Trigger, EffectReaction] = {}

func _init(definition: EffectDefinition) -> void:
	self.definition = definition
	duration = definition.max_duration
	stacks = definition.initial_stacks

	for trigger in definition.reactions.keys():
		reactions[trigger] = definition.reactions[trigger].duplicate(true)

func apply_stat_modifier(stat: StringName) -> void:
	if not definition.stat_modifiers.has(stat):
		return

	var operation: EffectDefinition.StatOperation = definition.stat_modifiers[stat]

	match operation:
		EffectDefinition.StatOperation.ADD:
			applied_stat_modifiers[stat] += stacks
	
		EffectDefinition.StatOperation.REST:
			applied_stat_modifiers[stat] -= stacks

		EffectDefinition.StatOperation.MULTIPLY:
			applied_stat_modifiers[stat] *= stacks

func disapply_stat_modifier(stat: StringName) -> void:
	if not definition.stat_modifiers.has(stat):
		return

	var operation: EffectDefinition.StatOperation = definition.stat_modifiers[stat]

	match operation:
		EffectDefinition.StatOperation.ADD:
			applied_stat_modifiers[stat] -= stacks
	
		EffectDefinition.StatOperation.REST:
			applied_stat_modifiers[stat] += stacks

		EffectDefinition.StatOperation.MULTIPLY:
			applied_stat_modifiers[stat] /= stacks
