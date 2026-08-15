class_name RegisterService
extends Node

signal update

var logs: Array[String] = []

func register_event(event: String) -> void:
	logs.append(event)
	update.emit()

	if logs.size() > 50:
		logs.pop_front()

func get_last_events(count: int = 5) -> Array[String]:
	return logs.slice(max(logs.size() - count, 0), logs.size())
