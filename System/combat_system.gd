class_name CombatSystem
extends Node

signal register_action(label: String)
signal end_action

# ------------------------------------------------------------------------
# EVENTS
# ------------------------------------------------------------------------

func attack_event(attacker: Being, target: Entity) -> void:
	var context := AttackContext.new()

	context.attacker = attacker

	if target is Thing:
		context.target = Being.new()
		AttackSystem.attack_thing(context)
	else:
		context.target = target
		AttackSystem.attack_being(context)

	attacker.turn.consuming_point(TurnComponent.TypePoint.ACTION)
	_process_attack(context)

func counter_attack_event(attacker: Being, target: Being) -> void:
	var context := AttackContext.new()

	context.attacker = attacker
	context.target = target

	AttackSystem.attack_being(context)
	context.result.reaction = false

	_process_attack(context)

func opportunity_attack_event(attacker: Being, target: Being) -> void:
	var context := AttackContext.new()

	context.attacker = attacker
	context.target = target

	AttackSystem.attack_being(context)

	context.result.reaction = false
	context.result.opportunity = true

	_process_attack(context)

func deal_damage_event(target: Being, damage: int) -> void:
	_apply_damage(target.health, damage)

func heal_event(target: Being, amount: int) -> void:
	_apply_heal(target.health, amount)

func kill_event(target: Being) -> void:
	if target.health.current_health > 0:
		target.health.current_health = 0

func revive_event(target: Being, health: int = 1) -> void:
	target.health.current_health = clamp(
		health,
		1,
		target.health.max_health
	)

func redirect_damage_event(
	target: Entity,
	attack: AttackContext
) -> void:
	attack.target = target
	_process_attack(attack)

func split_damage_event(
	targets: Array[HealthComponent],
	damage: int
) -> void:

	if targets.is_empty():
		return

	var split := damage / targets.size()
	var remainder := damage % targets.size()

	for i in targets.size():
		var value := split

		if i == 0:
			value += remainder

		_apply_damage(targets[i], value)

#func convert_type_damage_event(
	#context: AttackContext,
	#new_type: DamageType
#) -> void:
	#context.result.damage_type = new_type

# ------------------------------------------------------------------------
# INTERNAL
# ------------------------------------------------------------------------

func _process_attack(context: AttackContext) -> void:
	if context.cancelled:
		return

	_apply_damage(
		context.target.health,
		context.result.total_damage
	)

	_apply_heal(
		context.attacker.health,
		context.result.life_stolen
	)

	_restore_energy(
		context.attacker.energy,
		context.result.energy_stolen
	)

	_apply_attack_reactions(context)
	_dispatch_events(context)

	for effect in context.result.effects:
		_apply_effects(context.target.effects, effect)

	var a := context.attacker.name
	var b := context.target.name

	register_action.emit("%s lanza un ataque contra %s" % [a, b])

	if context.result.evaded:
		register_action.emit("%s lo evita" % b)

	elif context.result.weak:
		register_action.emit("%s realiza un golpe débil" % a)

	if context.result.critical:
		register_action.emit("%s realiza un ataque crítico" % a)

	if context.result.blocked:
		register_action.emit(
			"%s bloquea %d de daño"
			% [b, context.result.blocked_damage]
		)

	register_action.emit(
		"%s recibe %d de daño"
		% [b, context.result.total_damage]
	)

	if context.result.energy_stolen > 0:
		register_action.emit(
			"%s roba %d de energía"
			% [a, context.result.energy_stolen]
		)

	if context.result.life_stolen > 0:
		register_action.emit(
			"%s roba %d de vida"
			% [a, context.result.life_stolen]
		)

	if context.result.reflected_damage > 0:
		register_action.emit(
			"%s refleja %d de daño"
			% [b, context.result.reflected_damage]
		)

	if context.result.reaction:
		register_action.emit("%s contraataca" % b)
		counter_attack_event(context.target, context.attacker)
	else:
		end_action.emit()

func _apply_damage(target:HealthComponent, damage:int) -> void:
	if damage <= 0:
		return
	
	HealthSystem.apply_damage(target, damage)

func _apply_heal(target:HealthComponent, heal:int) -> void:
	if heal <= 0:
		return
	
	HealthSystem.heal(target, heal)

func _restore_energy(target:EnergyComponent,amount:int) -> void:
	if amount <= 0:
		return

	HealthSystem.restore_energy(target,amount)

func _spend_energy(target:EnergyComponent,amount:int) -> void:
	if amount <= 0:
		return

	HealthSystem.spend_energy(target,amount)

func _apply_effects(target:EffectComponent,effect:EffectDefinition) -> void:
	EffectSystem.add_effect(target,effect)

#func _mofify_stat(
	#target:StatsComponent,
	#stat:StringName,
	#amount:float
#) -> void:
	#pass

#func _remove_effects(target:EffectComponent,effect:EffectInstance) -> void:
	#EffectSystem.remove_effect(target,effect)

#func teleport(target:PositionComponent,position:Vector2i) -> void:
	##movement.move_unit(target,[position])
	#pass

func _apply_attack_reactions(context: AttackContext) -> void:
	HealthSystem.apply_damage(
		context.attacker.health,
		context.result.reflected_damage
	)

func _dispatch_events(context: AttackContext) -> void:
	#esto es para la animacion
	#CombatEvents.attack_processed.emit(context)
	pass
