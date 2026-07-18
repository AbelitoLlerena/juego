class_name AttackProcessor
extends Node

@onready var movement:MovementSystem

func setup(movement_system:MovementSystem):
	movement = movement_system

func process_attack(context: AttackContext) -> void:
	if context.cancelled:
		return

	_apply_damage(context.target.health,context.result.total_damage)
	_apply_heal(context.attacker.health,context.result.life_stolen)
	_restore_energy(context.attacker.energy,context.result.energy_stolen)
	_apply_attack_reactions(context)
	_dispatch_events(context)
	
	for effect in context.result.effects:
		_apply_effects(context.target.effects,effect)

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
	#aplicar dano reflejado y dano absorbido
	pass

func _dispatch_events(context: AttackContext) -> void:
	#esto es para la animacion
	#CombatEvents.attack_processed.emit(context)
	pass
