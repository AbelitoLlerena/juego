class_name AttackSystem
extends RefCounted

static func attack_being(context:AttackContext) -> void:
	_build_attack_stats(context)
	_calculate_hit(context)
	
	if context.result.evaded:
		return

	_calculate_critical(context)
	var damage := _calculate_raw_damage(context)
	_calculate_block(context, damage)
	_apply_armor(context, damage)
	_apply_resistances(context, damage)
	
	context.result.magical_damage = damage["magical"]
	context.result.physical_damage = damage["physical"]
	context.result.true_damage = damage["true"]

	_calculate_secondary_effects(context)
	_calculate_total_damage(context)
	_calculate_damage_reduction(context)
	_calculate_life_steal(context)
	_calculate_energy_steal(context)
	_calculate_reactions(context)

static func attack_thing(context:AttackContext) -> void:
	_calculate_base_damage(context)
	var damage := _calculate_raw_damage(context)
	
	context.result.magical_damage = damage["magical"]
	context.result.physical_damage = damage["physical"]
	context.result.true_damage = damage["true"]

	_calculate_total_damage(context)

static func _build_attack_stats(context: AttackContext) -> void:
	_calculate_base_damage(context)
	_calculate_precision(context)
	_calculate_critical_stats(context)
	_calculate_armor_penetration(context)
	_calculate_steal_stats(context)
	_calculate_effect_chances(context)

static func _calculate_base_damage(context: AttackContext) -> void:
	context.stats.physical_damage = \
		context.attacker.stats.base_physical_damage

	context.stats.magical_damage = \
		context.attacker.stats.base_magical_damage

	context.stats.true_damage = \
		context.attacker.stats.true_damage

static func _calculate_precision(context: AttackContext) -> void:
	context.stats.precision = \
		context.attacker.stats.precision

	context.stats.precision += context.tags["precision"]

static func _calculate_critical_stats(context: AttackContext) -> void:
	context.stats.critical_chance = \
		context.attacker.stats.crit_chance

	context.stats.critical_multiplier += \
		context.attacker.stats.crit_multiplier

static func _calculate_armor_penetration(context: AttackContext) -> void:
	context.stats.armor_penetration = \
		context.attacker.stats.armor_penetration

	context.stats.armor_penetration += \
		context.tags["armor_penetration"]

static func _calculate_steal_stats(context: AttackContext) -> void:
	context.stats.life_steal = \
		context.attacker.stats.life_steal

	context.stats.energy_steal = \
		context.attacker.stats.energy_steal

static func _calculate_effect_chances(context: AttackContext) -> void:
	context.stats.effect_chances.clear()

	#for effect in context.weapon.effects:
		#context.stats.effect_chances[effect] = effect.chance

static func _calculate_hit(context: AttackContext) -> void:
	var weak:float = context.attacker.stats.weak_chance
	
	var hit:float = context.attacker.stats.precision
	var evade:float = context.target.stats.dodge_chance

	context.result.weak = randf() <= weak
	if randf() <= hit-evade:
		if context.result.weak:
			context.result.evaded = true
		else: 
			context.result.weak = true

static func _calculate_critical(context: AttackContext) -> void:
	if context.result.weak:
		context.result.critical = false
	else:
		context.result.critical = \
			randf() <= context.stats.critical_chance

static func _calculate_raw_damage(context: AttackContext) -> Dictionary[String,float]:
	var physical:int = context.stats.physical_damage
	var magical:int = context.stats.magical_damage
	var true_damage:int = context.stats.true_damage

	var multiplier:float = 1

	if context.result.weak:
		multiplier = 0.5
	elif context.result.critical:
		multiplier = context.stats.critical_multiplier

	physical *= multiplier
	magical *= multiplier
	true_damage *= multiplier

	return {
		"physical": physical,
		"magical": magical,
		"true": true_damage
	}

static func _apply_armor(
	context: AttackContext,
	damage: Dictionary[String,float]
) -> Dictionary[String,float]:
	var armor = max(
		0,
		context.target.stats.armor * (1 - context.stats.armor_penetration)
	)

	var physical_damage = damage["physical"] - armor
	var magical_damage = damage["magical"] - armor / 3

	damage["physical"] = max(0, physical_damage)
	damage["magical"] = max(0, magical_damage)

	return damage

static func _calculate_block(
	context: AttackContext,
	damage: Dictionary[String,float]
) -> Dictionary[String,float]:

	if randf() > context.target.stats.block_chance:
		return damage

	context.result.blocked = true
	context.result.blocked_damage = 0

	if damage["physical"] >= context.target.stats.shield:
		var phisical_damage = damage["physical"] - context.target.stats.shield
		context.target.stats.shield = 0
		damage["physical"] = phisical_damage
		context.result.blocked_damage = phisical_damage
		return damage

	context.target.stats.shield -= damage["physical"]
	context.result.blocked_damage += damage["physical"]
	damage["physical"] = 0

	if damage["magical"] >= context.target.stats.shield:
		var magical_damage = damage["magical"] - context.target.stats.shield
		context.target.stats.shield = 0
		damage["magical"] = magical_damage
		context.result.blocked_damage = magical_damage
		return damage

	context.target.stats.shield -= damage["magical"]
	context.result.blocked_damage += damage["magical"]
	damage["magical"] = 0
	return damage

static func _apply_resistances(context: AttackContext, damage: Dictionary[String,float]) -> Dictionary[String,float]:
	var damage_physical = damage["physical"] - context.target.stats.resist_physical
	var damage_magical = damage["magical"] - context.target.stats.resist_magical

	damage["physical"] = max(0, damage_physical)
	damage["magical"] = max(0, damage_magical)

	return damage

static func _calculate_total_damage(context: AttackContext) -> void:
	context.result.total_damage = \
		context.result.physical_damage \
		+ context.result.magical_damage \
		+ context.result.true_damage

static func _calculate_damage_reduction(context: AttackContext) -> void:
	context.result.total_damage *= (1-context.target.stats.damage_reduction)

static func _calculate_secondary_effects(context: AttackContext) -> void:
	if context.result.weak:
		return

	for effect in context.stats.effect_chances:
		var chance = context.stats.effect_chances[effect]

		if randf() <= chance + chance * context.result.critical:
			var application := EffectDefinition.new()

			application.effect = effect
			application.source = context.attacker
			application.target = context.target

			context.result.effects.append(application)

static func _calculate_life_steal(context: AttackContext) -> void:
	context.result.life_stolen = int(
		context.result.total_damage
		* context.stats.life_steal
	)

static func _calculate_energy_steal(context: AttackContext) -> void:
	context.result.energy_stolen = int(
		context.result.total_damage
		* context.stats.energy_steal
	)

static func _calculate_reactions(context: AttackContext) -> void:
	context.result.reflected_damage = \
		context.result.total_damage*context.target.stats.damage_reflection

	if randf() < context.target.stats.counterattack_chance:
		context.result.reaction = true
