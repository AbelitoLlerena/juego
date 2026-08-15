class_name GetRelationSelector
extends EnumSelector

@export var source_selector: EntitySelector
@export var target_selector: EntitySelector

func get_enum(context) -> int:
	var source = source_selector.get_entity(context)
	var target = target_selector.get_entity(context)

	if source == null or target == null:
		return -1

	return FactionSystem.get_relation(
		source.faction,
		target.faction
	)
