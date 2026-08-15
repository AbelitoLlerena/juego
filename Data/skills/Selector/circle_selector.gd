class_name CircleSelector
extends SkillTileSelector

var _radius: int

func  _init(radius: int) -> void:
	_radius = radius

func casting(
	caster: Being,
	skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	await cursor.primary_click

	var tiles := AreaService.circle(
		cursor.state.grid_position,
		_radius
	)

	return tiles
	
