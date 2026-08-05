class_name AISystem
extends Node

@export var _pathfinding_system: PathfindingSystem
@export var _grid_system: GridSystem

signal final_decition(action:EventDefinition)

func setup(
	pathfinding_system: PathfindingSystem,
	grid_system: GridSystem
) -> void:
	_grid_system = grid_system
	_pathfinding_system = pathfinding_system

func analice(actor: Enemy) -> void:
	var context = AIContext.new()

	context.actor = actor
	context._grid = _grid_system
	context._pathfinding = _pathfinding_system

	_get_position_free(context)
	_get_faction_entities(context)

	final_decition.emit(actor.ai.decide(context))

func _get_position_free(context: AIContext) -> void:
	context.reachable_tiles = \
		context.actor.vision.visible_tiles.filter(
			_grid_system.is_cell_free
		)

func _get_faction_entities(context: AIContext) -> void:
	for entity in context.actor.vision.visible_entities:
		if entity is not Being:
			continue
		
		if FactionSystem.get_relation(
			context.actor.faction,
			entity.faction
		) == SkillTargetType.SkillTargetFilter.ENEMY:
			context.visible_enemies.append(entity)
		else:
			context.visible_allies.append(entity)
