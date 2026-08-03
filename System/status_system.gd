class_name StatusSystem
extends RefCounted

static func process_turn(being: Being) -> void:
	being.status.process_turn(being)
