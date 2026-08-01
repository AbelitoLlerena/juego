class_name AdyacetCasterSelector
extends SkillSelector

func casting(
	caster_position: Vector2i,
	caster_faction: FactionComponent,
	cursor: CursorSystem
) -> Array[Vector2i]:
	var tiles := AreaService.circle(caster_position, 1)
	tiles.erase(caster_position)
	return tiles
