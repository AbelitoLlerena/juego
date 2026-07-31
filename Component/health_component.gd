class_name HealthComponent
extends Resource

signal health_changed(current: int, maximum: int)

@export var max_health: int = 100
@export var health: int = 100
var regen_bar: float = 0.0


@export var is_dead:bool = false
@export var invulnerable:bool = false

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	health_changed.emit(health, max_health)
