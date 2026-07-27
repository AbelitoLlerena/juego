class_name MeleeAI
extends AIComponent

func decide(context: AIContext) -> ActionDecision:
	var decision := ActionDecision.new()

	if context.enemies.is_empty():
		decision.type = ActionDecision.Type.WAIT
		return decision

	var tuple:Array = _find_closest_enemy(context)
	var target:Being = tuple[0]
	var path:Array[Vector2i] = tuple[1]

	if target == null:
		decision.type = ActionDecision.Type.WAIT
		return decision

	if context.me.stats.range >= path.size():
		decision.type = ActionDecision.Type.ATTACK
		decision.target = target
		return decision

	var destination := path[0]

	if destination != context.self.grid_position:
		decision.type = ActionDecision.Type.MOVE
		decision.tile = destination
		return decision

	decision.type = ActionDecision.Type.WAIT
	return decision


func _find_closest_enemy(context: AIContext) -> Array:
	var closest: Being
	var closest_path = []
	var best_distance := INF

	for enemy in context.enemies:
		var path:Array[Vector2i] = context.path.find_path(
			context.me,
			enemy.c_position.grid_position
		)
		var distance:int = path.size()

		if distance < best_distance:
			best_distance = distance
			closest_path = path
			closest = enemy

	return [closest, best_distance]
