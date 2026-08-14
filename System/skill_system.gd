class_name SkillSystem
extends Node

@export var _grid_system: GridSystem
@export var _cursor_system: CursorSystem
@export var _animation_system: AnimationSystem
@export var _grid_service: GridService

signal emit_event(event: EventDefinition)

var casting := false

var _area_preview: SkillAreaPreview
var _dispatch: Callable
var _cancelled := false

func setup(
	grid_system: GridSystem,
	cursor_system: CursorSystem,
	animation_system: AnimationSystem,
	grid_service: GridService,
	area_preview: SkillAreaPreview,
	dispatch: Callable
) -> void:
	_grid_system = grid_system
	_cursor_system = cursor_system
	_animation_system = animation_system
	_grid_service = grid_service
	_area_preview = area_preview
	_dispatch = dispatch

func cancel() -> void:
	if not casting:
		return
	_cancelled = true
	_cursor_system.cancel_targeting()

func activate_skill(
	caster: Being,
	skill: SkillDefinition
) -> void:
	if casting:
		return
	if not skill.enable:
		return
	if caster.skills.is_on_cooldown(skill):
		return
	if not caster.turn.consuming_point(TurnComponent.TypePoint.ACTION, skill.action_cost):
		return

	casting = true
	_cancelled = false

	var context := SkillContext.new()
	context.caster = caster
	context.skill = SkillInstance.new(skill)

	var first_stage_done := false
	await _process_skill(context, first_stage_done)

	if _area_preview != null:
		_area_preview.clear()
	_cursor_system.pop_condition()
	casting = false
	_cancelled = false

func _process_skill(context: SkillContext, first_stage_done: bool) -> void:
	for stage in context.skill.definition.stages:
		var execution := await _resolve_execution(context, stage)
		if _cancelled or execution.tiles.is_empty():
			if not first_stage_done:
				context.caster.turn.restore_point(
					TurnComponent.TypePoint.ACTION,
					context.skill.skill_action_cost
				)
			return

		if not first_stage_done:
			context.caster.skills.trigger_cooldown(context.skill.definition)
			first_stage_done = true

		await _play_stage_fx(context, execution)
		await _process_execution(context, execution)
		if _stage_has_teleport(execution):
			await _play_blink_in(context.caster)

func _resolve_execution(
	context: SkillContext,
	stage: SkillStageDefinition
) -> SkillExecution:
	var execution := SkillExecution.new()
	var on_cursor := func(_state: CursorState):
		if _area_preview == null:
			return
		_area_preview.set_cells(
			stage.selector.preview_tiles(
				context.caster,
				context.skill,
				_cursor_system
			),
			stage.selector.preview_color()
		)

	_cursor_system.cursor_updated.connect(on_cursor)
	on_cursor.call(_cursor_system.state)

	execution.tiles = await stage.selector.casting(
		context.caster,
		context.skill,
		_cursor_system
	)

	if _cursor_system.cursor_updated.is_connected(on_cursor):
		_cursor_system.cursor_updated.disconnect(on_cursor)
	if _area_preview != null:
		_area_preview.clear()

	execution.rules = stage.rules
	if not execution.tiles.is_empty():
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
			if rule.condition == null:
				continue
			if not rule.condition.check(evaluation_context):
				continue

			var action = rule.action
			action.context = evaluation_context
			await _emit(action)

func _play_stage_fx(
	context: SkillContext,
	execution: SkillExecution
) -> void:
	if _stage_has_teleport(execution):
		await _play_command(FadeAnimationCommand.new(context.caster, 0.0, 0.12))
		return

	if _stage_has_damage(execution):
		await _play_command(
			ExplosionAnimationCommand.new(execution.tiles, _grid_service)
		)

func _stage_has_teleport(execution: SkillExecution) -> bool:
	for rule in execution.rules:
		if rule.action is SkillTeleportEvent:
			return true
	return false

func _stage_has_damage(execution: SkillExecution) -> bool:
	for rule in execution.rules:
		if rule.action is SkillDamageEvent:
			return true
	return false

func _play_blink_in(caster: Being) -> void:
	await _play_command(FadeAnimationCommand.new(caster, 1.0, 0.14))

func _play_command(command: AnimationCommand) -> void:
	if _animation_system == null or _animation_system.is_playing():
		return
	var sequence := AnimationSequence.new()
	var batch := AnimationBatch.new()
	batch.add(command)
	sequence.add_batch(batch)
	await _animation_system.play(sequence)

func _emit(event: EventDefinition) -> void:
	if _dispatch.is_valid():
		await _dispatch.call(event)
	else:
		emit_event.emit(event)

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
