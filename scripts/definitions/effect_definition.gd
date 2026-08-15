class_name EffectDefinition
extends Resource

enum StatOperation {
	ADD,
	REST,
	MULTIPLY,
}

@export var effect_name : String
@export var description : String
@export var icon : Texture2D

@export var max_stacks: int = 1
@export var max_duration: int = -1
@export var initial_stacks: int = 1

@export var stat_modifiers: Dictionary[StringName, StatOperation]
@export var reactions: Dictionary[EffectTrigger.Trigger, EffectReaction]
