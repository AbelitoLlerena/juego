class_name SkillSystem
extends Node

@export var cursor_system: CursorSystem
@export var grid_system: GridSystem

func request_target_tiles(
	skill:SkillDefinition,
	caster_position:Vector2i,
	caster_faction: FactionComponent
) -> Dictionary[SkillTargetType.SkillTargetFilter, Array]:
	var selected_tiles: Dictionary[SkillTargetType.SkillTargetFilter, Array] = {}

	if skill is SkillMultiTarget:
		var count:int = 0
		while count < skill.target_type.size():
			#aplicar condition cursor
			await cursor_system.primary_click

			selected_tiles[count] = [cursor_system.state.grid_position]
			count += 1

			var tile := cursor_system.state.grid_position
			#selected_tiles.append(tile)

	else:
		await cursor_system.primary_click
		
		var tiles:Array[Vector2i] = AreaService.get_skill_area(
			caster_position,
			cursor_system.state.grid_position,
			skill
		)

		for type in skill.target_type:
			selected_tiles[type] = []

		for tile in tiles:
			if tile == caster_position:
				continue

			var entity:Entity = grid_system.get_entity(tile)

			if entity is Thing:
				continue

			var relation:SkillTargetType.SkillTargetFilter =\
			 FactionSystem.get_relation(caster_faction, entity.faction)

			if skill.target_type.has(relation):
				selected_tiles[relation].append(tile)

			if skill.target_type.has(
				SkillTargetType.SkillTargetFilter.ANY
			):
				selected_tiles[relation].append(tile)

	if skill.target_type.has(
		SkillTargetType.SkillTargetFilter.SELF
	):
		selected_tiles[SkillTargetType.SkillTargetFilter.SELF]\
		.append(caster_position)

	return selected_tiles

func activate_skill(
	caster: Player,
	skill: SkillDefinition,
	grid: GridSystem
) -> void:
	var context := SkillContext.new()
	context.caster = caster
	context.skill = skill

	context.target_tiles = await request_target_tiles(
		skill,
		context.caster.c_position.grid_position,
		context.caster.faction
	)

	process_ability(context)

func process_ability(context:SkillContext) -> void:
	pass
