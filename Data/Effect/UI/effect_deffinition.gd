class_name EffectDefinition
extends Resource

@export var id : StringName

@export var display_name : String

@export_multiline var description : String

@export var icon : Texture2D

@export var max_stacks := 1

@export var default_duration := -1

@export var rules : Array[EffectRule]
