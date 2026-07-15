class_name SkillDefinition
extends Resource

@export var id : StringName
@export var display_name : String
@export_multiline var description := ""

@export var icon : Texture2D

@export var action_cost := 1
@export var mana_cost := 0
@export var cooldown := 0
@export var range := 1

@export var rules : Array[SkillRule]
