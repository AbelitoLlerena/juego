class_name CombatSystem
extends Node

@onready var _movement:MovementSystem

signal register_action(label: String)
signal end_action

func setup(movement_system:MovementSystem):
	_movement = movement_system

func attack(
	attacker: Being, 
	target: Entity,
) -> void:
	var context := AttackContext.new()

	context.attacker = attacker
	
	if target is Thing:
		context.target = Being.new()
		AttackSystem.attack_thing(context)
		
	else:
		context.target = target
		AttackSystem.attack_being(context)

	process_attack(context)

func counterattack(
	attacker: Being, 
	target: Being,
) -> void:
	var context := AttackContext.new()

	context.attacker = attacker
	context.target = target

	AttackSystem.attack_thing(context)
	context.result.reaction = false
	process_attack(context)

func process_attack(context: AttackContext) -> void:
	if context.cancelled:
		return

	_apply_damage(context.target.health,context.result.total_damage)
	_apply_heal(context.attacker.health,context.result.life_stolen)
	_restore_energy(context.attacker.energy,context.result.energy_stolen)
	_apply_attack_reactions(context)
	_dispatch_events(context)
	
	for effect in context.result.effects:
		if context.target is Being:
			var effect_context := EffectContext.new()
			effect_context.bearer = context.target
			EffectSystem.add_effect(context.target.effect, effect, effect_context)

	var a = context.attacker.name
	var b = context.target.name

	register_action.emit("%s lanza un ataque contra %s" % [a, b])

	if context.result.evaded:
		register_action.emit("%s lo evita" % b)

	elif context.result.weak:
		register_action.emit("%s realiza un golpe débil" % a)

	if context.result.critical:
		register_action.emit("%s realiza un ataque crítico" % a)

	if context.result.blocked:
		register_action.emit("%s bloquea %d de daño" % [b, context.result.blocked_damage])

	register_action.emit("%s recibe %d de daño" % [b, context.result.total_damage])
	
	if context.result.energy_stolen > 0:
		register_action.emit("%s roba %d de energía" % [a, context.result.energy_stolen])

	if context.result.life_stolen > 0:
		register_action.emit("%s roba %d de vida" % [a, context.result.life_stolen])

	if context.result.reflected_damage > 0:
		register_action.emit("%s refleja %d de daño" % [b, context.result.reflected_damage])

	if context.result.reaction:
		register_action.emit("%s contraataca" % b)
		counterattack(context.target,context.attacker)

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

func _mofify_stat(
	target:StatsComponent,
	stat:StringName,
	amount:float
) -> void:
	pass

func _remove_effects(target:EffectComponent,effect:EffectInstance) -> void:
	EffectSystem.remove_effect(target,effect)

func teleport(target:PositionComponent,position:Vector2i) -> void:
	#movement.move_unit(target,[position])
	pass

func _apply_attack_reactions(context: AttackContext) -> void:
	HealthSystem.apply_damage(
		context.attacker.health,
		context.result.reflected_damage
	)

func _dispatch_events(context: AttackContext) -> void:
	#esto es para la animacion
	#CombatEvents.attack_processed.emit(context)
	pass
