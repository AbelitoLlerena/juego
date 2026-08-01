class_name HealthSystem
extends RefCounted

signal register_event(event: Label)

static func apply_damage(
	health: HealthComponent,
	amount: int
) -> int:
	if amount <= 0:
		return 0

	var previous := health.health
	health.set_health(health.health - amount)
	return previous - health.health

static func heal(
	health: HealthComponent,
	amount: int
) -> int:
	if amount <= 0:
		return 0

	var previous := health.health
	health.set_health(health.health + amount)
	return health.health - previous

static func spend_energy(
	energy: EnergyComponent,
	amount: int
) -> bool:
	if amount <= 0:
		return true

	if energy.energy < amount:
		return false

	energy.energy -= amount
	return true

static func restore_energy(
	energy: EnergyComponent,
	amount: int
) -> int:
	if amount <= 0:
		return 0

	var previous := energy.energy

	energy.energy = min(
		energy.max_energy,
		energy.energy + amount
	)

	return energy.energy - previous

static func is_alive(
	health: HealthComponent
) -> bool:
	return health.health > 0

static func is_dead(
	health: HealthComponent
) -> bool:
	return health.health <= 0

static func revive(
	health: HealthComponent,
	amount := 1
) -> void:
	health.set_health(clampi(amount, 1, health.max_health))

static func refill(
	health: HealthComponent,
	energy: EnergyComponent
) -> void:
	health.set_health(health.max_health)
	energy.energy = energy.max_energy

static func process_turn(entity: Being) -> void:
	entity.health.regen_bar += entity.stats.health_restoration
	
	if entity.health.regen_bar >= 1.0:
		entity.health.regen_bar = 0
		var heal_amount = int(entity.health.max_health * entity.stats.healing_efficiency)
		entity.health.set_health(entity.health.health + heal_amount)
		print("Regenerado: %d HP, vida actual: %d" % [heal_amount, entity.health.health])
