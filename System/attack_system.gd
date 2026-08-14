class_name AttackSystem
extends RefCounted

static func attack_being(context:AttackContext) -> void:
	_build_attack_stats(context)

	EffectSystem.apply_effect_event(
		context.attacker,
		EffectTrigger.Trigger.ON_ATTACK,
		context
	)

	EffectSystem.apply_effect_event(
		context.target,
		EffectTrigger.Trigger.ON_HIT,
		context
	)

	_calculate_hit(context)
	if context.result.evaded:
		return

	if !context.result.weak:
		_calculate_critical(context.stats,context.result)
		_calculate_secondary_effects(context.stats,context.result)
	_calculate_raw_damage(context)
	_calculate_block(context)
	_apply_armor(context)
	_apply_resistances(context)

	_calculate_total_damage(context)
	_calculate_damage_reduction(context)
	_calculate_life_steal(context)
	_calculate_reactions(context)

static func attack_thing(context:AttackContext) -> void:
	_calculate_attack_damage(context)
	_calculate_critical_stats(context.attacker, context.stats)

	_calculate_critical(context.stats,context.result)
	_calculate_raw_damage(context)

	_calculate_total_damage(context)

static func caster_skill_damage(context: AttackContext) -> void:
	_calculate_precision(context)
	_calculate_critical_stats(context.attacker, context.stats)
	_calculate_armor_penetration(context)
	_calculate_steal_stats(context)
	_calculate_effect_chances(context.stats)

	EffectSystem.apply_effect_event(
		context.attacker,
		EffectTrigger.Trigger.ON_CASTER,
		context
	)

	EffectSystem.apply_effect_event(
		context.target,
		EffectTrigger.Trigger.ON_HIT,
		context
	)

	_calculate_hit(context)
	if context.result.evaded:
		return

	if !context.result.weak:
		_calculate_critical(context.stats,context.result)
		_calculate_secondary_effects(context.stats,context.result)
	_calculate_raw_damage(context)
	_calculate_block(context)
	_apply_armor(context)
	_apply_resistances(context)

	_calculate_total_damage(context)
	_calculate_damage_reduction(context)
	_calculate_life_steal(context)

static func caster_skill_heal(context: HealContext) -> void:
	_calculate_critical_stats(context.healer,context.stats)
	_calculate_effect_chances(context.stats)

	EffectSystem.apply_effect_event(
		context.attacker,
		EffectTrigger.Trigger.ON_CASTER,
		context
	)

	_calculate_critical(context.stats,context.result)
	_calculate_total_heal(context)
	_calculate_secondary_effects(context.stats,context.result)

static func _build_attack_stats(context: AttackContext) -> void:
	_calculate_attack_damage(context)
	_calculate_precision(context)
	_calculate_critical_stats(context.attacker,context.stats)
	_calculate_armor_penetration(context)
	_calculate_steal_stats(context)
	_calculate_effect_chances(context.stats)

static func _calculate_attack_damage(context: AttackContext) -> void:
	var attack_damage = context.attacker.stats.attack_damage.duplicate()
	context.stats.damage = context.attacker.stats.attack_damage.duplicate()

static func _calculate_precision(context: AttackContext) -> void:
	context.stats.precision += \
		context.attacker.stats.get_stat(
			StatsComponent.Stat.PRECISION
		)

static func _calculate_critical_stats(
	actor: Being, 
	stats: BaseStatsContext
) -> void:
	stats.critical_chance += \
		actor.stats.get_stat(
			StatsComponent.Stat.CRIT_CHANCE
		)

	stats.critical_multiplier += \
		actor.stats.get_stat(
			StatsComponent.Stat.CRIT_BONUS
		)

static func _calculate_armor_penetration(context: AttackContext) -> void:
	context.stats.armor_penetration += \
		context.attacker.stats.get_stat(
			StatsComponent.Stat.ARMOR_PENETRATION
		)

static func _calculate_steal_stats(context: AttackContext) -> void:
	context.stats.life_steal += \
		context.attacker.stats.get_stat(
			StatsComponent.Stat.LIFE_STEAL
		)

static func _calculate_effect_chances(stats: BaseStatsContext) -> void:
	stats.effect_chances.clear()

	#for effect in context.weapon.effects:
		#context.stats.effect_chances[effect] = effect.chance

static func _calculate_hit(context: AttackContext) -> void:
	var weak: float = context.attacker.stats.get_stat(
		StatsComponent.Stat.WEAK_CHANCE
	)
	
	var evade: float = context.target.stats.get_stat(
		StatsComponent.Stat.DODGE_CHANCE
	)

	context.result.weak = randf() <= weak
	if randf() <= context.stats.precision - evade:
		if context.result.weak:
			context.result.evaded = true
		else:
			context.result.weak = true

static func _calculate_critical(
	stats: BaseStatsContext, 
	result: BaseResultContext
) -> void:
	result.critical = \
		randf() <= stats.critical_chance

static func _calculate_raw_damage(
	context: AttackContext
) -> void:

	var phisical_multiplier = context.attacker.stats.get_stat(
		StatsComponent.Stat.ATTACK_POWER
	)
	var magical_multiplier = context.attacker.stats.get_stat(
		StatsComponent.Stat.MAGICAL_POWER
	)

	if context.result.weak:
		phisical_multiplier *= 0.5
		magical_multiplier *= 0.5
	elif context.result.critical:
		phisical_multiplier += context.attacker.stats.get_stat(
			StatsComponent.Stat.CRIT_BONUS
		)
		magical_multiplier += context.attacker.stats.get_stat(
			StatsComponent.Stat.CRIT_BONUS
		)

	for damage_type in context.stats.damage.keys():
		if context.stats.damage.has(damage_type):
			context.stats.damage[damage_type] += (
				context.attacker.stats.attack_damage[damage_type]
				* phisical_multiplier 
				if DamageType.is_damage_phisical(damage_type)
				else magical_multiplier 
				if DamageType.is_damage_magical(damage_type)
				else 1
			)
		else:
			context.stats.damage[damage_type] = (
				context.attacker.stats.attack_damage[damage_type]
				* phisical_multiplier 
				if DamageType.is_damage_phisical(damage_type)
				else magical_multiplier 
				if DamageType.is_damage_magical(damage_type)
				else 1
			)

static func _apply_armor(
	context: AttackContext,
) -> void:
	var armor = max(
		0,
		context.target.stats.get_stat(
			StatsComponent.Stat.ARMOR
		) * (1 - context.stats.armor_penetration)
	)

	for damage_type in context.stats.damage.keys():
		var damage = context.stats.damage[damage_type] - (
			armor
			if DamageType.is_damage_phisical(damage_type)
			else armor / 3 
			if DamageType.is_damage_magical(damage_type)
			else 0
		)

		context.stats.damage[damage_type] = max(0, damage)

static func _calculate_block(
	context: AttackContext,
) -> void:

	if randf() > context.target.stats.get_stat(
		StatsComponent.Stat.BLOCK_CHANCE
	):
		return

	context.result.blocked = true
	var blocked_damage = 0
	var shield = context.target.stats.get_stat(
		StatsComponent.Stat.SHIELD
	)

	for damage_type in context.stats.damage.keys():
		if context.stats.damage[damage_type] >= shield:
			var damage = context.stats.damage[damage_type] - shield
			context.target.stats.set_stat(StatsComponent.Stat.SHIELD, 0)
			context.stats.damage[damage_type] = damage
			blocked_damage += shield
			break

		context.target.stats.set_stat(StatsComponent.Stat.SHIELD, shield)
		blocked_damage += context.stats.damage[damage_type]
		context.stats.damage[damage_type] = 0

	context.result.blocked_damage = int(blocked_damage)

static func _apply_resistances(
	context: AttackContext, 
) -> void:
	for damage_type in context.stats.damage.keys():
		context.stats.damage[damage_type] = max(
			0,
			context.stats.damage[damage_type] * (
				1 - context.target.stats.get_resistence_at(
					damage_type
				)
			)
		)

static func _calculate_total_damage(context: AttackContext) -> void:
	var total = 0
	for damage in context.stats.damage.values():
		total += damage

	context.result.total = total

static func _calculate_damage_reduction(context: AttackContext) -> void:
	context.result.total *= int(
		1 - context.target.stats.get_stat(
			StatsComponent.Stat.DAMAGE_REDUCTION
		)
	)

static func _calculate_secondary_effects(
	stats: BaseStatsContext, 
	result: BaseResultContext
) -> void:
	for effect in stats.effect_chances.keys():
		var chance = stats.effect_chances[effect]
		chance += chance * result.critical
		#aplicar resistencia a efectos

		if randf() <= chance:
			result.effects.append(effect)

static func _calculate_life_steal(context: AttackContext) -> void:
	context.result.life_stolen = int(
		context.result.total
		* context.stats.life_steal * (1 + 
			context.attacker.stats.get_stat(
				StatsComponent.Stat.HEALING_EFFICIENCY
			)
		)
	)

static func _calculate_reactions(context: AttackContext) -> void:
	context.result.reflected_damage = \
		context.result.total * \
		context.target.stats.get_stat(
			StatsComponent.Stat.DAMAGE_REFLECTION
		)

	if randf() <= context.target.stats.get_stat(
		StatsComponent.Stat.COUNTERATTACK_CHANCE
	):
		context.result.reaction = true

static  func _calculate_total_heal(context: HealContext) -> void:
	context.result.total = int(
		context.stats.base_heal
		* context.stats.critical_multiplier 
		if context.result.critical
		else 1.0
	)
