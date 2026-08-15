class_name ActionSystem
extends RefCounted

# Ejecuta una ActionDefinition contra un contexto.
# El contexto debe exponer al ser que recibe el efecto:
#   EffectContext.bearer  (flujo de efectos)
#   SkillContext.caster   (flujo de habilidades, duck-typing)

static func execute(action: ActionDefinition, context) -> void:
	if action == null:
		return

	if action is ActionSequence:
		for sub in action.sequence:
			execute(sub, context)
		return

	var bearer := _being_of(context)
	if bearer == null:
		return

	if action is DealDamageAction:
		var stacks := 1
		if action.per_stack:
			stacks = maxi(_current_stacks(context), 1)
		HealthSystem.apply_damage(bearer.health, action.amount * stacks)

	elif action is HealAction:
		HealthSystem.heal(bearer.health, action.amount)

	elif action is SpendEnergyAction:
		HealthSystem.spend_energy(bearer.energy, action.amount)

	elif action is RestoreEnergyAction:
		HealthSystem.restore_energy(bearer.energy, action.amount)

	elif action is AddStatusAction:
		EffectSystem.add_effect_event(
			bearer,
			action.effect,
			#action.duration
		)

	elif action is RemoveStatusAction:
		_remove_status(bearer, action)

	elif action is ModifyStatAction:
		_modify_stat(bearer, action)

	elif action is ModifyMovementAction:
		bearer.turn.movement_points = maxi(
			0,
			bearer.turn.movement_points + action.amount
		)

static func _being_of(context) -> Being:
	if "bearer" in context:
		return context.bearer
	if "caster" in context:
		return context.caster
	return null

static func _current_stacks(context) -> int:
	if not "bearer" in context or not "effect" in context:
		return 1
	if context.effect == null:
		return 1

	for instance in context.bearer.effect.effects:
		if instance.definition == context.effect:
			return instance.stacks
	return 1

static func _remove_status(bearer: Being, action: RemoveStatusAction) -> void:
	pass
	#for instance in bearer.effect.effects:
		#if instance.definition != null and instance.definition.id == action.effect_id:
			#EffectSystem.remove_effect_event(
				#bearer,
				#instance
			#)
			#return

static func _modify_stat(bearer: Being, action: ModifyStatAction) -> void:
	var stats := bearer.stats
	match action.stat:
		ModifyStatAction.Stat.ATTACK:
			stats.base_physical_damage = maxi(0, stats.base_physical_damage + int(action.amount))
		ModifyStatAction.Stat.DEFENSE:
			stats.armor = maxi(0, stats.armor + int(action.amount))
		ModifyStatAction.Stat.SPEED:
			stats.agility = maxi(0, stats.agility + int(action.amount))
		ModifyStatAction.Stat.CRIT:
			stats.crit_chance = maxf(0, stats.crit_chance + action.amount)
		ModifyStatAction.Stat.MAX_HEALTH:
			bearer.health.max_health = maxi(1, bearer.health.max_health + int(action.amount))
