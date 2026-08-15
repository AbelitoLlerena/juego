class_name EquipmentComponent
extends Resource

signal item_equipped(item: EquipmentItem, slot: InventorySlot.SlotType)
signal item_unequipped(item: EquipmentItem, slot: InventorySlot.SlotType)
signal equipment_changed

var _slots: Dictionary[EquipmentItem.EquipmentSlot,EquipmentItem] = {}

func _init() -> void:
	for slot_type in EquipmentItem.EquipmentSlot.values():
		_slots[slot_type] = null

func equip(item: EquipmentItem) -> EquipmentItem:
	if item == null:
		return null

	var slot := item.equipment_type

	var previous: EquipmentItem = _slots.get(slot, null)
	_slots[slot] = item
	item_equipped.emit(item, slot)
	equipment_changed.emit()
	return previous

func unequip(slot: EquipmentItem.EquipmentSlot) -> EquipmentItem:
	var item: EquipmentItem = _slots.get(slot, null)
	if item == null:
		return null

	_slots[slot] = null
	item_unequipped.emit(item, slot)
	equipment_changed.emit()
	return item

func get_equipped(slot: EquipmentItem.EquipmentSlot) -> EquipmentItem:
	return _slots.get(slot, null)

func is_slot_empty(slot: EquipmentItem.EquipmentSlot) -> bool:
	return _slots.get(slot, null) == null

func get_all_equipped() -> Array[EquipmentItem]:
	var result: Array[EquipmentItem] = []
	for item in _slots.values():
		if item != null:
			result.append(item)
	return result

func get_stat_modifiers() -> Dictionary[StatsComponent.Stat, float]:
	var modifiers: Dictionary[StatsComponent.Stat, float] = {}
	for item: EquipmentItem in _slots.values():
		if item == null:
			continue
		for stat_name in item.stats.keys():
			if not modifiers.has(stat_name):
				modifiers[stat_name] = 0.0
			modifiers[stat_name] += item.stats[stat_name]
	return modifiers

func get_weight() -> float:
	var total := 0.0
	for item in _slots.values():
		if item != null:
			total += item.weight
	return total

func is_empty() -> bool:
	for item in _slots.values():
		if item != null:
			return false
	return true

func clear() -> void:
	for slot in _slots.keys():
		_slots[slot] = null
	equipment_changed.emit()
