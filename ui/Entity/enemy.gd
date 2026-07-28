class_name Enemy 
extends Being

@export var ai: AIComponent
var combating: bool = false

func initialice() -> void:
	entity_name = "Johny"
	ai = MeleeAI.new()
