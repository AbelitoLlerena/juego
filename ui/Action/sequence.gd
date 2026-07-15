class_name ActionSequence
extends ActionDefinition

@export var sequence: Array[ActionDefinition]

func execute(context):
	for action in sequence:
		action.execute(context)
