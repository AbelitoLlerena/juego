class_name ExecutionTilesSelector
extends TileCollectionSelector

@export var _execution_name: String

func _init(execution_name: String) -> void:
	_execution_name = execution_name

func get_collection(context) -> Array[Vector2i]:
	return context.executions[_execution_name].tiles
