class_name SkillSystem
extends Node

@export var _cursor_system: CursorSystem
@export var _grid_system: GridSystem

func activate_skill(
	caster: Player,
	skill: SkillDefinition,
	grid: GridSystem
) -> void:
	var context := SkillContext.new()
	context.caster = caster
	context.skill = skill

	context.target_tiles = await skill.set_area(
		context.caster.c_position.grid_position,
		context.caster.faction,
		_cursor_system,
	)

	process_ability(context)

func process_ability(context:SkillContext) -> void:
	pass
