class_name EnergyComponent
extends Resource

signal energy_changed(current: int, maximum: int)

@export var max_energy: int = 100
@export var current: int = 100
@export var regen_bar: float = 0.0

func set_energy(value: int) -> void:
	current = clampi(value, 0, max_energy)
	energy_changed.emit(current, max_energy)
