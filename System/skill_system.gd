class_name SkillSystem
extends Node

@export var _grid_system: GridSystem
@export var _cursor_system: CursorSystem

func setup(
	grid_system: GridSystem,
	cursor_system: CursorSystem
) -> void:
	_grid_system = grid_system
	_cursor_system = cursor_system

func activate_skill(
	caster: Being,
	skill: SkillDefinition,
) -> void:
	var context := SkillContext.new()
	context.caster = caster
	context.skill = skill

	_resolve_execution(context)

	_process_skill(context)

func _resolve_execution(context: SkillContext) -> void:
	for stage in context.skill.stages:
		var execution = SkillExecution.new()
		execution.tiles = stage.selector.execute(
			context.caster.c_position.grid_position,
			context.caster.faction,
			_cursor_system
		)

		execution.rules = stage.rules

		context.executions[stage.id] = execution

func _process_skill(context: SkillContext) -> void:
	for execution in context.executions.values():
		for tile in execution.tiles:
			var context_evaluation := _create_context_evaluation(
				context.caster,
				context.executions,
				tile
			)
			
			for rule in execution.rules:
				if !rule.condition.check(context_evaluation):
					continue

				rule.action.execute(context)

func _create_context_evaluation(
	caster: Being,
	executions: Dictionary[String,SkillExecution],
	tile: Vector2i
) -> SkillEvaluationContext:
	var context = SkillEvaluationContext.new()

	context.caster = caster
	context.executions = executions
	context.tile = tile
	context.entity = _grid_system.get_entity(tile)

	return context
