class_name InventorySlot
extends Resource

enum SlotType {
	NONE,
	EQUIPMENT,
	CONSUMABLE,
	MATERIAL
}

@export var slot_type: SlotType = SlotType.NONE
@export var item: ItemDefinition = null
@export var quantity: int = 0


func is_empty() -> bool:
	return item == null


func can_stack_with(other: ItemDefinition) -> bool:
	if is_empty() or other == null:
		return false

	return item.id == other.id and quantity < item.max_stack


func space_available() -> int:
	if is_empty():
		return 0

	return item.max_stack - quantity


func add_quantity(amount: int) -> int:
	if is_empty() or amount <= 0:
		return amount

	var can_add := space_available()
	var to_add := mini(amount, can_add)

	quantity += to_add

	return amount - to_add


func remove_quantity(amount: int) -> int:
	if amount <= 0 or is_empty():
		return 0

	var to_remove := mini(amount, quantity)
	quantity -= to_remove

	if quantity <= 0:
		item = null
		quantity = 0

	return to_remove


func get_weight() -> float:
	if is_empty() or item.weight < 0:
		return 0.0

	return item.weight * quantity
