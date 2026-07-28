class_name AISystem
extends Node

@onready var grid_system: GridSystem
@onready var faction_system: FactionSystem

func decide(entity: Being) -> ActionDecision:
	var context := _build_context(entity)

	return entity.ai.decide(context)

func _build_context(entity: Being) -> AIContext:
	var context := AIContext.new()

	context.me = entity

	context.grid = grid_system

	#context.allies = faction_system.get_allies(entity)
	#context.enemies = faction_system.get_enemies(entity)

	#context.visible_enemies = _get_visible_enemies(entity, context.enemies)

	#context.reachable_tiles = grid_system.get_reachable_tiles(
		#entity.grid_position,
		#entity.stats.movement
	#)

	#context.visible_tiles = visibility_system.get_visible_tiles(entity)

	return context

func _get_visible_enemies(
	entity: Being
) -> Array[Being]:

	var visible: Array[Being] = []

	#for enemy in enemies:
		#if visibility_system.can_see(entity, enemy):
			#visible.append(enemy)

	return visible
