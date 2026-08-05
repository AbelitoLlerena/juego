class_name HealthSystem
extends RefCounted

signal register_event(event: Label)

static func apply_damage(
	health: HealthComponent,
	amount: int
) -> int:
	if amount <= 0:
		return 0

	var previous := health.current
	health.set_health(health.current - amount)
	return previous - health.current

static func heal(
	health: HealthComponent,
	amount: int
) -> int:
	if amount <= 0:
		return 0

	var previous := health.current
	health.set_health(health.current + amount)
	return health.current - previous

static func spend_energy(
	energy: EnergyComponent,
	amount: int
) -> bool:
	if amount <= 0:
		return true

	if energy.current < amount:
		return false

	var previous := energy.current
	energy.set_health(energy.current - amount)
	return true

static func restore_energy(
	energy: EnergyComponent,
	amount: int
) -> int:
	if amount <= 0:
		return 0

	var previous := energy.current
	energy.set_energy(previous + amount)

	return energy.energy - previous

static func is_alive(
	health: HealthComponent
) -> bool:
	return not health.is_dead

static func is_dead(
	health: HealthComponent
) -> bool:
	return health.is_dead

static func revive(
	health: HealthComponent,
	amount := 1
) -> void:
	if not health.is_dead:
		return
	health.set_health(clampi(amount, 1, health.max_health))
	health.is_dead = false

static func kill(target: HealthComponent):
	target.set_health(0)

static func refill(
	health: HealthComponent,
	energy: EnergyComponent
) -> void:
	health.set_health(health.max_health)
	energy.energy = energy.max_energy

static func process_turn(entity: Being) -> void:
	entity.health.regen_bar += entity.stats.health_restoration
	entity.energy.regen_bar += entity.stats.energy_regeneration

	if entity.health.regen_bar >= 1.0:
		entity.health.regen_bar = 0
		var heal_amount = int(entity.health.max_health * entity.stats.healing_efficiency)
		entity.health.set_health(entity.health.current + heal_amount)
		print("Regenerado: %d HP, vida actual: %d" % [heal_amount, entity.health.current])
	
	if entity.energy.regen_bar >= 1.0:
			entity.energy.regen_bar = 0
			var energing_amount = int(entity.energy.max_energy * entity.stats.energing_efficiency)
			entity.energy.set_energy(entity.energy.current + energing_amount)
			print("Regenerado: %d HP, vida actual: %d" % [energing_amount, entity.energy.current])
