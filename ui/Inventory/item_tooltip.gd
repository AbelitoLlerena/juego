class_name ItemTooltipUI
extends PanelContainer

var _name_label: Label
var _type_label: Label
var _description_label: Label
var _stats_container: VBoxContainer
var _weight_label: Label


const RARITY_NAMES := {
	ItemDefinition.Rarity.COMMON: "Común",
	ItemDefinition.Rarity.UNCOMMON: "Poco común",
	ItemDefinition.Rarity.RARE: "Raro",
	ItemDefinition.Rarity.EPIC: "Épico",
	ItemDefinition.Rarity.LEGENDARY: "Legendario",
}


const EQUIPMENT_SLOT_NAMES := {
	EquipmentItem.EquipmentSlot.WEAPON: "Arma",
	EquipmentItem.EquipmentSlot.HELMET: "Casco",
	EquipmentItem.EquipmentSlot.ARMOR: "Armadura",
	EquipmentItem.EquipmentSlot.BOOTS: "Botas",
	EquipmentItem.EquipmentSlot.GLOVES: "Guantes",
	EquipmentItem.EquipmentSlot.RING: "Anillo",
	EquipmentItem.EquipmentSlot.NECKLACE: "Collar",
	EquipmentItem.EquipmentSlot.BELT: "Cinturón",
	EquipmentItem.EquipmentSlot.EARRING: "Arete",
}


func _init() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size = Vector2(0, 0)

	var bg := ColorRect.new()
	bg.color = Color(0.15, 0.15, 0.18, 0.95)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	margin.add_child(vbox)

	_name_label = Label.new()
	_name_label.add_theme_font_size_override("font_size", 14)
	_name_label.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(_name_label)

	_type_label = Label.new()
	_type_label.add_theme_font_size_override("font_size", 11)
	_type_label.add_theme_color_override(
		"font_color",
		Color(0.7, 0.7, 0.7)
	)
	vbox.add_child(_type_label)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	_description_label = Label.new()
	_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_description_label.add_theme_font_size_override("font_size", 11)
	_description_label.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(_description_label)

	_stats_container = VBoxContainer.new()
	_stats_container.add_theme_constant_override("separation", 2)
	vbox.add_child(_stats_container)

	var sep2 := HSeparator.new()
	vbox.add_child(sep2)

	_weight_label = Label.new()
	_weight_label.add_theme_font_size_override("font_size", 11)
	_weight_label.add_theme_color_override(
		"font_color",
		Color(0.7, 0.7, 0.7)
	)
	vbox.add_child(_weight_label)


func show_for(item: ItemDefinition) -> void:
	if item == null:
		hide()
		return

	_clear_stats()

	_name_label.text = item.name

	var rarity_color: Color = ItemSlotUI.RARITY_COLORS.get(
		item.rarity,
		Color.WHITE
	)
	_name_label.add_theme_color_override(
		"font_color",
		rarity_color
	)

	_type_label.text = _get_type_text(item)
	_description_label.text = item.description

	_add_item_stats(item)
	_add_item_use_effect(item)

	if item.weight >= 0:
		_weight_label.text = "Peso: %.1f" % item.weight
	else:
		_weight_label.text = ""

	visible = true


func hide_tooltip() -> void:
	hide()


func _get_type_text(item: ItemDefinition) -> String:
	var type_text := ""

	if item is EquipmentItem:
		var equipment := item as EquipmentItem
		type_text = EQUIPMENT_SLOT_NAMES.get(
			equipment.equipment_type,
			"Equipamiento"
		)

	elif item is ConsumableItem:
		type_text = "Consumible"

	else:
		type_text = "Objeto"

	var rarity_name: String = RARITY_NAMES.get(
		item.rarity,
		""
	)

	if rarity_name != "":
		type_text += " - " + rarity_name

	return type_text


func _add_item_stats(item: ItemDefinition) -> void:
	if not item is EquipmentItem:
		return

	var equipment := item as EquipmentItem

	for stat in equipment.stats:
		var value: float = equipment.stats[stat]

		if is_zero_approx(value):
			continue

		_add_stat_label(stat, value)


func _add_stat_label(
	stat: StatsComponent.Stat,
	value: float
) -> void:
	var stat_label := Label.new()
	stat_label.add_theme_font_size_override("font_size", 11)

	var display_name: String = StatsComponent.STAT_DISPLAY_NAMES.get(
		stat,
		"stat invalid"
	)

	var value_text := _format_stat_value(value)

	stat_label.text = "%s %s" % [
		display_name,
		value_text
	]

	if value > 0:
		stat_label.add_theme_color_override(
			"font_color",
			Color(0.3, 1.0, 0.3)
	)
	else:
		stat_label.add_theme_color_override(
			"font_color",
			Color(1.0, 0.4, 0.4)
		)

	_stats_container.add_child(stat_label)


func _format_stat_value(value: float) -> String:
	var prefix := "+" if value > 0 else ""

	if value == int(value):
		return "%s%d" % [prefix, int(value)]

	return "%s%.1f" % [prefix, value]


func _add_item_use_effect(item: ItemDefinition) -> void:
	if not item is ConsumableItem:
		return

	var consumable := item as ConsumableItem

	if consumable.use_action == &"":
		return

	var action_text := _get_use_action_text(consumable)

	if action_text == "":
		return

	var action_label := Label.new()
	action_label.add_theme_font_size_override("font_size", 11)
	action_label.add_theme_color_override(
		"font_color",
		Color(0.5, 0.8, 1.0)
	)
	action_label.text = action_text

	_stats_container.add_child(action_label)


func _get_use_action_text(item: ConsumableItem) -> String:
	match item.use_action:
		&"heal":
			return "Cura %d HP" % item.use_value

		&"restore_energy":
			return "Restaura %d energía" % item.use_value

		&"revive":
			return "Revive con %d HP" % item.use_value

		_:
			return String(item.use_action)


func _clear_stats() -> void:
	for child in _stats_container.get_children():
		child.queue_free()
