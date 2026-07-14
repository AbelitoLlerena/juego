class_name HealthSystem
extends RefCounted

static func apply_damage(
	health: HealthComponent,
	amount: int
) -> int:

	if amount <= 0:
		return 0

	var previous := health.health
	health.health = max(0, health.health - amount)
	return previous - health.health

static func heal(
	health: HealthComponent,
	amount: int
) -> int:

	if amount <= 0:
		return 0

	var previous := health.health

	health.health = min(
		health.max_health,
		health.health + amount
	)

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

	health.health = clamp(
		amount,
		1,
		health.max_health
	)

static func refill(
	health: HealthComponent,
	energy: EnergyComponent
) -> void:

	health.health = health.max_health
	energy.energy = energy.max_energy
