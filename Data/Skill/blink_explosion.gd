class_name BlinkExplosion
extends SkillDefinition

func _init():
	display_name = "Blink Explosion"
	cooldown = 4
	mana_cost = 20

	stages = [
		_create_explosion(),
		_create_teleport(),
		_create_stun(),
	]

func _create_explosion() -> SkillStageDefinition:
	var stage := SkillStageDefinition.new()

	stage.id = "explosion"
	stage.selector = CircleSelector.new(3)
	stage.rules = [
		DamageEnemyRule.new(25),
		HealAllyRule.new(25)
	]

	return stage

func _create_teleport():
	var stage := SkillStageDefinition.new()

	stage.id = "teleport"
	stage.selector = TileFreeSelector.new()
#
	stage.rules = [
		TeleportRule.new()
	]

	return stage

func _create_stun():
	var stage := SkillStageDefinition.new()

	stage.id = "stun"
	stage.selector = AdyacetCasterSelector.new()

	stage.rules = [
		StunInExecutionRule.new("explosion")
	]

	return stage
