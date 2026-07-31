class_name EquipmentSystem
extends Node

signal item_used(item: ItemDefinition, user: Being)
signal stats_recalculated(being: Being)
signal item_dropped(item: ItemDefinition, quantity: int)

func equip_item(being: Being, item: ItemDefinition) -> ItemDefinition:
	if item == null or not item.is_equipment():
		return null

	if being.equipment == null or being.inventory == null:
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

func unequip_item(being: Being, slot: ItemDefinition.SlotType) -> ItemDefinition:
	if being.equipment == null or being.inventory == null:
		return null

	if being.inventory.is_full():
		return null

	var item := being.equipment.unequip(slot)
	if item == null:
		return null

	being.inventory.add_item(item, 1)
	recalculate_stats(being)
	return item

func use_item(being: Being, item: ItemDefinition) -> bool:
	if item == null or not item.is_consumable():
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
	if stats._base_stats.is_empty():
		stats.save_base_stats()

	var modifiers := being.equipment.get_stat_modifiers()

	stats.strength = int(stats.get_base_stat("strength")) + int(modifiers.get("strength", 0))
	stats.agility = int(stats.get_base_stat("agility")) + int(modifiers.get("agility", 0))
	stats.intelligence = int(stats.get_base_stat("intelligence")) + int(modifiers.get("intelligence", 0))
	stats.constitution = int(stats.get_base_stat("constitution")) + int(modifiers.get("constitution", 0))

	stats.base_physical_damage = int(stats.get_base_stat("base_physical_damage")) + int(modifiers.get("base_physical_damage", 0))
	stats.base_magical_damage = int(stats.get_base_stat("base_magical_damage")) + int(modifiers.get("base_magical_damage", 0))
	stats.true_damage = int(stats.get_base_stat("true_damage")) + int(modifiers.get("true_damage", 0))

	stats.crit_chance = float(stats.get_base_stat("crit_chance")) + modifiers.get("crit_chance", 0.0)
	stats.crit_bonus = float(stats.get_base_stat("crit_bonus")) + modifiers.get("crit_bonus", 0.0)
	stats.precision = float(stats.get_base_stat("precision")) + modifiers.get("precision", 0.0)
	stats.weak_chance = float(stats.get_base_stat("weak_chance")) + modifiers.get("weak_chance", 0.0)

	stats.armor_penetration = float(stats.get_base_stat("armor_penetration")) + modifiers.get("armor_penetration", 0.0)
	stats.magic_penetration = float(stats.get_base_stat("magic_penetration")) + modifiers.get("magic_penetration", 0.0)
	stats.crit_multiplier = float(stats.get_base_stat("crit_multiplier")) + modifiers.get("crit_multiplier", 0.0)

	stats.life_steal = float(stats.get_base_stat("life_steal")) + modifiers.get("life_steal", 0.0)
	stats.energy_steal = float(stats.get_base_stat("energy_steal")) + modifiers.get("energy_steal", 0.0)

	stats.counterattack_chance = float(stats.get_base_stat("counterattack_chance")) + modifiers.get("counterattack_chance", 0.0)
	stats.combo_chance = float(stats.get_base_stat("combo_chance")) + modifiers.get("combo_chance", 0.0)
	stats.combo_damage = float(stats.get_base_stat("combo_damage")) + modifiers.get("combo_damage", 0.0)

	stats.armor = int(stats.get_base_stat("armor")) + int(modifiers.get("armor", 0))
	stats.shield = stats.strength + int(modifiers.get("shield", 0))
	stats.block_chance = float(stats.get_base_stat("block_chance")) + modifiers.get("block_chance", 0.0)
	stats.dodge_chance = float(stats.get_base_stat("dodge_chance")) + modifiers.get("dodge_chance", 0.0)
	stats.damage_reflection = float(stats.get_base_stat("damage_reflection")) + modifiers.get("damage_reflection", 0.0)
	stats.tenacity = float(stats.get_base_stat("tenacity")) + modifiers.get("tenacity", 0.0)
	stats.damage_reduction = float(stats.get_base_stat("damage_reduction")) + modifiers.get("damage_reduction", 0.0)

	stats.health_restoration = float(stats.get_base_stat("health_restoration")) + modifiers.get("health_restoration", 0.0)
	stats.healing_efficiency = float(stats.get_base_stat("healing_efficiency")) + modifiers.get("healing_efficiency", 0.0)
	stats.energy_regeneration = float(stats.get_base_stat("energy_regeneration")) + modifiers.get("energy_regeneration", 0.0)
	stats.energing_efficiency = float(stats.get_base_stat("energing_efficiency")) + modifiers.get("energing_efficiency", 0.0)

	for resistance_key in stats.resistances:
		stats.resistances[resistance_key] = int(stats.get_base_stat("resistances").get(resistance_key, 0)) + int(modifiers.get(resistance_key, 0))

	stats_recalculated.emit(being)

func _apply_use_effect(being: Being, item: ItemDefinition) -> bool:
	match item.use_action:
		&"heal":
			if being.health == null:
				return false
			var healed := HealthSystem.heal(being.health, item.use_value)
			return healed > 0
		&"restore_energy":
			if being.energy == null:
				return false
			var restored := HealthSystem.restore_energy(being.energy, item.use_value)
			return restored > 0
		&"revive":
			if being.health == null:
				return false
			HealthSystem.revive(being.health, item.use_value)
			return true
		_:
			return false
