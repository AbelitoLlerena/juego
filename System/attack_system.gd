class_name AttackSystem
extends RefCounted

func resolve(context: AttackContext) -> void:
	_build_attack_stats(context)
	_calculate_hit(context)
	
	if context.result.evaded:
		return

	_calculate_critical(context)
	_apply_resistances(
		context,
		_calculate_raw_damage(context)
	)
	_calculate_secondary_effects(context)
	_calculate_total_damage(context)
	_calculate_life_steal(context)
	_calculate_energy_steal(context)
	#_calculate_reactions(context)

func _build_attack_stats(context: AttackContext) -> void:
	_calculate_base_damage(context)
	_calculate_precision(context)
	_calculate_critical_stats(context)
	_calculate_armor_penetration(context)
	_calculate_steal_stats(context)
	_calculate_effect_chances(context)

func _calculate_base_damage(context: AttackContext) -> void:
	context.stats.physical_damage = \
		context.attacker.stats.base_physical_damage

	context.stats.magical_damage = \
		context.attacker.stats.base_magical_damage

	context.stats.true_damage = \
		context.attacker.stats.true_damage

func _calculate_precision(context: AttackContext) -> void:
	context.stats.precision = \
		context.attacker.stats.precision

	context.stats.precision += context.tags["precision"]

func _calculate_critical_stats(context: AttackContext) -> void:
	context.stats.critical_chance = \
		context.attacker.stats.crit_chance

	context.stats.critical_multiplier += \
		context.attacker.stats.crit_multiplier

func _calculate_armor_penetration(context: AttackContext) -> void:
	context.stats.armor_penetration = \
		context.attacker.stats.armor_penetration

	context.stats.armor_penetration += \
		context.tags["armor_penetration"]

func _calculate_steal_stats(context: AttackContext) -> void:
	context.stats.life_steal = \
		context.attacker.stats.life_steal

	context.stats.energy_steal = \
		context.attacker.stats.energy_steal

func _calculate_effect_chances(context: AttackContext) -> void:
	context.stats.effect_chances.clear()

	for effect in context.weapon.effects:
		context.stats.effect_chances[effect] = effect.chance

func _calculate_hit(context: AttackContext) -> void:
	var weak:float = context.attacker.stats.weak_chance
	
	var hit:float = context.attacker.stats.precision
	var evade:float = context.target.stats.dodge_chance

	context.result.weak = randf() <= weak
	if randf() <= hit-evade:
		if context.result.weak:
			context.result.evaded = true
		else: 
			context.result.weak = true

func _calculate_critical(context: AttackContext) -> void:
	if context.result.weak:
		context.result.critical = false
	else:
		context.result.critical = \
			randf() <= context.stats.critical_chance

func _calculate_raw_damage(context: AttackContext) -> Dictionary:
	var physical:int = context.stats.physical_damage
	var magical:int = context.stats.magical_damage
	var true_damage:int = context.stats.true_damage

	if context.result.critical:
		var multiplier:float = context.stats.critical_multiplier

		physical *= multiplier
		magical *= multiplier
		true_damage *= multiplier

	return {
		"physical": physical,
		"magical": magical,
		"true": true_damage
	}

func _apply_resistances(context: AttackContext, damage: Dictionary) -> Dictionary:
	var damage_physical = damage["physical"] - context.target.stats.resistances["physical"]
	var damage_magical = damage["magical"] - context.stats.resistances["magical"]

	damage["physical"] = max(0, damage_physical)
	damage["magical"] = max(0, damage_magical)

	return damage

func _calculate_total_damage(context: AttackContext) -> void:
	context.result.total_damage = \
		context.result.physical_damage \
		+ context.result.magical_damage \
		+ context.result.true_damage

func _calculate_secondary_effects(context: AttackContext) -> void:
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

func _calculate_life_steal(context: AttackContext) -> void:
	context.result.life_stolen = int(
		context.result.total_damage
		* context.stats.life_steal
	)

func _calculate_energy_steal(context: AttackContext) -> void:
	context.result.energy_stolen = int(
		context.result.total_damage
		* context.stats.energy_steal
	)

#func _calculate_reactions(context: AttackContext) -> void:
	#if context.target.can_counter_attack(context):
		#context.result.reflected_damage = \
			#context.target.get_counter_damage()
