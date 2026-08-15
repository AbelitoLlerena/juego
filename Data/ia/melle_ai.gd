class_name MeleeAI
extends AIComponent

func decide(context: AIContext) -> EventDefinition:
	if context.visible_enemies.is_empty():
		return EndTurnEvent.new()

	var tuple:Array = _find_closest_enemy(context)
	var target:Being = tuple[0]
	var path:Array[Vector2i] = tuple[1]

	if target == null:
		return EndTurnEvent.new()

	if context.actor.stats.get_stat(
		StatsComponent.Stat.RANGE
	) >= DistanceService.distance(
		context.actor.c_position.grid_position,
		target.c_position.grid_position
	) and context.actor.turn.action_points > 0:
		var decision := AttackEvent.new()
		decision.attacker = context.actor
		decision.target = target
		return decision

	var destination := path[0]

	if destination != target.c_position.grid_position and \
	context.actor.turn.movement_points > 0:
		var decision := WalkEvent.new()
		decision.entity = context.actor
		decision.destination = destination
		return decision

	return EndTurnEvent.new()


func _find_closest_enemy(context: AIContext) -> Array:
	var closest: Being
	var closest_path = []
	var best_distance := INF

	for enemy in context.visible_enemies:
		var path:Array[Vector2i] = context._pathfinding.find_path(
			context.actor.c_position.grid_position,
			enemy.c_position.grid_position
		)
		var distance:int = path.size()

		if distance < best_distance:
			best_distance = distance
			closest_path = path
			closest = enemy

	return [closest, closest_path]
