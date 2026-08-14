class_name InputCollector
extends Node2D

signal mouse_moved(position: Vector2)
signal primary_clicked()
signal cancel_requested()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_moved.emit(get_global_mouse_position())

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			primary_clicked.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_requested.emit()
