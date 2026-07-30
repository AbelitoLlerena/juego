class_name EquipmentComponent
extends Resource

signal item_equipped(item: ItemDefinition, slot: ItemDefinition.SlotType)
signal item_unequipped(item: ItemDefinition, slot: ItemDefinition.SlotType)
signal equipment_changed

var _slots: Dictionary = {}

func _init() -> void:
	for slot_type in ItemDefinition.SlotType.values():
		if slot_type != ItemDefinition.SlotType.NONE:
			_slots[slot_type] = null

func equip(item: ItemDefinition) -> ItemDefinition:
	if item == null or not item.is_equipment():
		return null

	var slot := item.slot_type
	if slot == ItemDefinition.SlotType.NONE:
		return null

	var previous: ItemDefinition = _slots.get(slot, null)
	_slots[slot] = item
	item_equipped.emit(item, slot)
	equipment_changed.emit()
	return previous

func unequip(slot: ItemDefinition.SlotType) -> ItemDefinition:
	if slot == ItemDefinition.SlotType.NONE:
		return null

	var item: ItemDefinition = _slots.get(slot, null)
	if item == null:
		return null

	_slots[slot] = null
	item_unequipped.emit(item, slot)
	equipment_changed.emit()
	return item

func get_equipped(slot: ItemDefinition.SlotType) -> ItemDefinition:
	return _slots.get(slot, null)

func is_slot_empty(slot: ItemDefinition.SlotType) -> bool:
	return _slots.get(slot, null) == null

func get_all_equipped() -> Array[ItemDefinition]:
	var result: Array[ItemDefinition] = []
	for slot in _slots:
		if _slots[slot] != null:
			result.append(_slots[slot])
	return result

func get_stat_modifiers() -> Dictionary:
	var modifiers := {}
	for slot in _slots:
		var item: ItemDefinition = _slots[slot]
		if item == null:
			continue
		for stat_name in item.stats:
			if not modifiers.has(stat_name):
				modifiers[stat_name] = 0.0
			modifiers[stat_name] += item.stats[stat_name]
	return modifiers

func get_weight() -> float:
	var total := 0.0
	for slot in _slots:
		var item: ItemDefinition = _slots[slot]
		if item != null:
			total += item.weight
	return total

func is_empty() -> bool:
	for slot in _slots:
		if _slots[slot] != null:
			return false
	return true

func clear() -> void:
	for slot in _slots:
		_slots[slot] = null
	equipment_changed.emit()
