class_name AdyacetCasterSelector
extends SkillTileSelector

func casting(
	caster: Being,
	skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	var tiles := AreaService.circle(
		caster.c_position.grid_position, 
		1
	)

	tiles.erase(caster.c_position.grid_position)
	return tiles
