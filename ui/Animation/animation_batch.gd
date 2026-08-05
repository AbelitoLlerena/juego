class_name AnimationBatch
extends RefCounted

var commands: Array[AnimationCommand] = []

func add(command: AnimationCommand) -> AnimationBatch:
	commands.append(command)
	return self
