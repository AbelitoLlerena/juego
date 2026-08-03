class_name IsDeadSelector
extends BoolSelector

var entity_selector: EntitySelector

func get_bool(context) -> bool:
	var entity = entity_selector.get_entity(context)
	
	if entity == null:
		return false
		
	return entity.health.is_dead
