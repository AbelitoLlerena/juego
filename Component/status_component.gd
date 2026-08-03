class_name StatusComponent
extends Resource

# Clase común para Player y Enemy (ambos extienden Being).
# Controla los estados aplicados a un personaje y sus efectos.

enum Type {
	POISON,
	SLOWED,
	BURN
}

# type -> { "stacks": int, "remaining_turns": int }
var _status: Dictionary = {}

func has(type: Type) -> bool:
	return _status.has(type)

func get_stacks(type: Type) -> int:
	var entry: Dictionary = _status.get(type, {})
	return int(entry.get("stacks", 0))

func remaining_turns(type: Type) -> int:
	var entry: Dictionary = _status.get(type, {})
	return int(entry.get("remaining_turns", 0))

func apply(type: Type, stacks: int, turns: int) -> void:
	if stacks <= 0:
		return

	var entry: Dictionary = _status.get_or_add(type, {
		"stacks": 0,
		"remaining_turns": 0
	})
	entry["stacks"] = maxi(entry["stacks"], stacks)
	entry["remaining_turns"] = maxi(entry["remaining_turns"], turns)

func remove(type: Type) -> void:
	_status.erase(type)

func clear() -> void:
	_status.clear()

# Efectos de los estados cada turno. Devuelve el daño total aplicado.
func process_turn(being: Being) -> int:
	var total := 0
	var to_remove: Array[Type] = []

	for type in _status.keys():
		var entry: Dictionary = _status[type]
		var stacks := int(entry.get("stacks", 0))
		var turns := int(entry.get("remaining_turns", 0))

		match type:
			Type.POISON:
				total += HealthSystem.apply_damage(being.health, stacks * _damage_per_stack(Type.POISON))
			Type.BURN:
				total += HealthSystem.apply_damage(being.health, stacks * _damage_per_stack(Type.BURN))

		entry["remaining_turns"] = turns - 1
		if entry["remaining_turns"] <= 0:
			to_remove.append(type)

	for type in to_remove:
		_status.erase(type)

	return total

func _damage_per_stack(type: Type) -> int:
	match type:
		Type.POISON:
			return 1
		Type.BURN:
			return 2
	return 0