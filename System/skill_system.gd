class_name SkillSystem
extends Node

@export var _grid_system: GridSystem
@export var _cursor_system: CursorSystem

signal emit_event(event: EventDefinition)

func setup(
	grid_system: GridSystem,
	cursor_system: CursorSystem
) -> void:
	_grid_system = grid_system
	_cursor_system = cursor_system


func activate_skill(
	caster: Being,
	skill: SkillDefinition
) -> void:
	var context := SkillContext.new()
	context.caster = caster
	context.skill = SkillInstance.new(skill)

	var event = ApplyEffectEvent.new()
	event.trigger = EffectTrigger.Trigger.ON_CASTER
	event.target = caster
	event.context = context

	emit_event.emit(event)

	_process_skill(context)

func _process_skill(context: SkillContext) -> void:
	for stage in context.skill.definition.stages:
		var execution := await _resolve_execution(context, stage)
		_process_execution(context, execution)

func _resolve_execution(
	context: SkillContext,
	stage: SkillStageDefinition
) -> SkillExecution:
	var execution := SkillExecution.new()

	execution.tiles = await stage.selector.casting(
		context.caster,
		context.skill,
		_cursor_system
	)

	execution.rules = stage.rules
	context.executions[stage.id] = execution

	return execution

func _process_execution(
	context: SkillContext,
	execution: SkillExecution
) -> void:
	for tile in execution.tiles:
		var evaluation_context := _create_context_evaluation(
			context.caster,
			context.executions,
			tile
		)

		for rule in execution.rules:
			if !rule.enabled:
				continue

			if rule.condition != null:
				if rule.condition.check(evaluation_context):
					emit_event.emit(rule.action)

func _create_context_evaluation(
	caster: Being,
	executions: Dictionary[String, SkillExecution],
	tile: Vector2i
) -> SkillEvaluationContext:
	var context := SkillEvaluationContext.new()

	context.caster = caster
	context.executions = executions
	context.tile = tile
	context.entity = _grid_system.get_entity(tile)

	return context
