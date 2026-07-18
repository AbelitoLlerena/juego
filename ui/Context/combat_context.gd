class_name CombatContext
extends RefCounted

var id: int
var cancelled := false

# Información auxiliar para sistemas.
var metadata := {}

func cancel() -> void:
	cancelled = true
