class_name AISystem
extends Node

@export var pathfinding_system: PathfindingSystem
@export var grid_system: GridSystem

signal final_decition(action:ActionDefinition)

func setup(
	pathfinding_system: PathfindingSystem,
	grid_system: GridSystem
) -> void:
	self.grid_system = grid_system
	self.pathfinding_system = pathfinding_system

func analice(actor: Enemy) -> void:
	var context = AIContext.new()

	context.actor = actor
	context._grid = grid_system
	context._pathfinding = pathfinding_system

	_get_position_free(context)
	_get_faction_entities(context)

	final_decition.emit(actor.ai.decide(context))
			

func _get_position_free(context: AIContext) -> void:
	context.reachable_tiles = \
		context.actor.vision.visible_tiles.filter(
			grid_system.is_cell_free
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
