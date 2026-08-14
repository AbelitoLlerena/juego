class_name EquipmentSystem
extends Node

signal item_used(item: EquipmentItem, user: Being)
signal stats_recalculated(being: Being)
signal item_dropped(item: ItemDefinition, quantity: int)

func equip_item(being: Being, item: EquipmentItem) -> EquipmentItem:
	if item == null:
		return null

	if being == null or being.equipment == null or being.inventory == null:
		return null

	var slot_index := being.inventory.find_slot_index(item.id)
	if slot_index == -1:
		return null

	var previous := being.equipment.equip(item)

	being.inventory.remove_item(item.id, 1)

	if previous != null:
		being.inventory.add_item(previous, 1)

	recalculate_stats(being)
	return previous

func unequip_item(
	being: Being, 
	slot: EquipmentItem.EquipmentSlot
) -> EquipmentItem:
	if being == null or being.equipment == null or being.inventory == null:
		return null

	if being.inventory.is_full():
		return null

	var item := being.equipment.unequip(slot)
	if item == null:
		return null

	being.inventory.add_item(item, 1)
	recalculate_stats(being)
	return item

func use_item(being: Being, item: ConsumableItem) -> bool:
	if item == null:
		return false

	if being.inventory == null:
		return false

	if not being.inventory.has_item(item.id, 1):
		return false

	var success := _apply_use_effect(being, item)
	if success:
		being.inventory.remove_item(item.id, 1)
		item_used.emit(item, being)
	return success

func drop_item(being: Being, item: ItemDefinition, qty: int = 1) -> int:
	if being.inventory == null:
		return 0

	var removed := being.inventory.remove_item(item.id, qty)
	if removed > 0:
		item_dropped.emit(item, removed)
	return removed

func recalculate_stats(being: Being) -> void:
	if being.equipment == null or being.stats == null:
		return

	var stats := being.stats
	if not stats.stats:
		stats = StatsComponent.new()

	var modifiers := being.equipment.get_stat_modifiers()

	for stat: StatsComponent.Stat in modifiers.keys():
		stats.modify_stat(
			stat,
			modifiers[stat]
		)

	stats_recalculated.emit(being)

func _apply_use_effect(being: Being, item: ConsumableItem) -> bool:
	match item.use_action:
		&"heal":
			if being.health == null:
				return false
			var healed := HealthSystem.heal(being.health, item.use_value)
			return healed > 0
		&"revive":
			if being.health == null:
				return false
			HealthSystem.revive(being.health, item.use_value)
			return true
		_:
			return false
