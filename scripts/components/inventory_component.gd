class_name InventoryComponent
extends Resource

signal item_added(item: ItemDefinition, quantity: int)
signal item_removed(item: ItemDefinition, quantity: int)
signal inventory_changed

@export var capacity: int = 30
@export var items: Array[InventorySlot] = []

func add_item(item: ItemDefinition, qty: int = 1) -> int:
	if item == null or qty <= 0:
		return qty

	var remaining := qty

	if item.is_stackable():
		remaining = _stack_into_existing(item, remaining)

	while remaining > 0 and items.size() < capacity:
		var slot := InventorySlot.new()

		# Cada InventorySlot tiene su propia instancia del item.
		slot.item = item.duplicate()
		slot.quantity = 0

		remaining = slot.add_quantity(remaining)

		items.append(slot)

	var added := qty - remaining

	item_added.emit(item, added)
	inventory_changed.emit()

	return remaining
	
func remove_item(id: StringName, qty: int = 1) -> int:
	if qty <= 0:
		return 0

	var remaining := qty
	var to_remove: Array[int] = []
	var removed_item: ItemDefinition = null

	for i in items.size():
		if remaining <= 0:
			break

		var slot := items[i]

		if slot.item == null or slot.item.id != id:
			continue

		if removed_item == null:
			removed_item = slot.item

		var removed := slot.remove_quantity(remaining)
		remaining -= removed

		if slot.is_empty():
			to_remove.append(i)

	to_remove.reverse()

	for i in to_remove:
		items.remove_at(i)

	var total_removed := qty - remaining

	# La señal se emite siempre que se haya removido algo.
	item_removed.emit(removed_item, total_removed)
	inventory_changed.emit()

	return total_removed

func has_item(id: StringName, qty: int = 1) -> bool:
	return get_item_count(id) >= qty

func get_item_count(id: StringName) -> int:
	var total := 0
	for slot in items:
		if slot.item != null and slot.item.id == id:
			total += slot.quantity
	return total

func find_slot_index(id: StringName) -> int:
	for i in items.size():
		if items[i].item != null and items[i].item.id == id:
			return i
	return -1

func find_slots(id: StringName) -> Array[int]:
	var result: Array[int] = []
	for i in items.size():
		if items[i].item != null and items[i].item.id == id:
			result.append(i)
	return result

func is_full() -> bool:
	return items.size() >= capacity

func get_total_weight() -> float:
	var total := 0.0
	for slot in items:
		total += slot.get_weight()
	return total

func swap_slots(i: int, j: int) -> void:
	if i < 0 or i >= items.size() or j < 0 or j >= items.size():
		return
	var temp := items[i]
	items[i] = items[j]
	items[j] = temp
	inventory_changed.emit()

func get_sorted_items() -> Array[InventorySlot]:
	var result := items.duplicate()
	result.sort_custom(func(a: InventorySlot, b: InventorySlot) -> bool:
		if a.item == null:
			return false
		if b.item == null:
			return true
		if a.item.item_type != b.item.item_type:
			return a.item.item_type < b.item.item_type
		if a.item.rarity != b.item.rarity:
			return a.item.rarity > b.item.rarity
		return a.item.name < b.item.name
	)
	return result

func clear() -> void:
	items.clear()
	inventory_changed.emit()

func _stack_into_existing(item: ItemDefinition, qty: int) -> int:
	var remaining := qty
	for slot in items:
		if remaining <= 0:
			break
		if slot.can_stack_with(item):
			remaining = slot.add_quantity(remaining)
	return remaining

func _find_item_definition(id: StringName) -> ItemDefinition:
	for slot in items:
		if slot.item != null and slot.item.id == id:
			return slot.item
	return null
