class_name BlinkExplosion
extends SkillDefinition

func _init():
	id = &"blink_explosion"
	display_name = "Explosión Blink"
	description = "Explota un área, parpadea a una celda libre y ralentiza a quien quede cerca."
	icon = preload("res://icon.svg")
	enable = true
	cooldown = 8
	action_cost = 3

	stages = [
		_create_explosion(),
		_create_teleport(),
		_create_slow(),
	]

func _create_explosion() -> SkillStageDefinition:
	var stage := SkillStageDefinition.new()

	stage.id = "explosion"
	stage.selector = CircleSelector.new(3)
	stage.rules = [
		DamageEnemyRule.new({
			DamageType.Type.FIRE: 25
		}),
		HealAllyRule.new(25)
	]

	return stage

func _create_teleport():
	var stage := SkillStageDefinition.new()

	stage.id = "teleport"
	stage.selector = TileFreeSelector.new()

	stage.rules = [
		TeleportRule.new()
	]

	return stage

func _create_slow():
	var stage := SkillStageDefinition.new()

	stage.id = "stun"
	stage.selector = AdyacetCasterSelector.new()

	stage.rules = [
		SlowInExecutionRule.new("explosion")
	]

	return stage
