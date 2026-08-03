class_name SizeSelector
extends ValueSelector

@export var collection_selector: CollectionSelector

func get_value(context) -> float:
	return collection_selector.get_collection(context).size()
