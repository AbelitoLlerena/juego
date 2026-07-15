class_name SkillContext
extends RefCounted

var caster

var skill : SkillDefinition

var selected_tile_principal : Vector2i
var selected_tile_secundary : Vector2i

var variables : Dictionary = {}

func set_value(name:StringName,value):
	variables[name]=value

func get_value(name:StringName,default_value=null):
	return variables.get(name,default_value)
