class_name SkillTileSelector
extends Resource

func casting(
	caster: Being,
	skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	return [caster.c_position.grid_position]
