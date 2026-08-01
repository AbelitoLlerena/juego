class_name SkillSelector
extends Resource

func casting(
	caster_position: Vector2i,
	caster_faction: FactionComponent,
	cursor: CursorSystem
) -> Array[Vector2i]:
	return [caster_position]
