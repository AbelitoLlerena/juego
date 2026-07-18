class_name AttackResult
extends RefCounted

var hit := true
var weak := false
var evaded := false
var blocked := false
var critical := false

var physical_damage := 0
var magical_damage := 0
var true_damage := 0

var total_damage := 0

var life_stolen := 0
var energy_stolen := 0

var reflected_damage := 0

var effects: Array[EffectDefinition] = []
