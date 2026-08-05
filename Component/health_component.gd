class_name HealthComponent
extends Resource

signal health_changed(current: int, maximum: int)

@export var max_health: int = 100
@export var current: int = 100
@export var regen_bar: float = 0.0


@export var is_dead:bool = false
@export var invulnerable:bool = false

func set_health(value: int) -> void:
	current = clampi(value, 0, max_health)
	health_changed.emit(current, max_health)

	if current == 0:
		is_dead = true
