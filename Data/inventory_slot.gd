class_name InventorySlot
extends Resource

@export var item: ItemDefinition = null
@export var quantity: int = 1

func is_empty() -> bool:
	return item == null or quantity <= 0

func can_stack_with(other: ItemDefinition) -> bool:
	if item == null or other == null:
		return false
	return item.id == other.id and quantity < item.max_stack

func space_available() -> int:
	if item == null:
		return 0
	return item.max_stack - quantity

func add_quantity(amount: int) -> int:
	if item == null:
		return amount
	var can_add := space_available()
	var to_add := mini(amount, can_add)
	quantity += to_add
	return amount - to_add

func remove_quantity(amount: int) -> int:
	var to_remove := mini(amount, quantity)
	quantity -= to_remove
	if quantity <= 0:
		item = null
		quantity = 0
	return to_remove

func get_weight() -> float:
	if item == null:
		return 0.0
	return item.weight * quantity
