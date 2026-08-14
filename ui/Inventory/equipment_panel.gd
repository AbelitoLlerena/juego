class_name EquipmentPanelUI
extends PanelContainer

signal unequip_pressed(slot: EquipmentItem.EquipmentSlot)

var _equipment: EquipmentComponent = null
var _stats: StatsComponent = null

var _equip_slots: Dictionary[EquipmentItem.EquipmentSlot, ItemSlotUI] = {}
var _stats_labels: Dictionary[StatsComponent.Stat, Label] = {}

var _unequip_btn: Button
var _selected_slot_type: EquipmentItem.EquipmentSlot = -1


const SLOT_LABELS := {
	EquipmentItem.EquipmentSlot.WEAPON: "Arma",
	EquipmentItem.EquipmentSlot.HELMET: "Casco",
	EquipmentItem.EquipmentSlot.ARMOR: "Armadura",
	EquipmentItem.EquipmentSlot.BOOTS: "Botas",
	EquipmentItem.EquipmentSlot.GLOVES: "Guantes",
	EquipmentItem.EquipmentSlot.BELT: "Cinturón",
	EquipmentItem.EquipmentSlot.RING: "Anillo",
	EquipmentItem.EquipmentSlot.NECKLACE: "Collar",
	EquipmentItem.EquipmentSlot.EARRING: "Aretes",
}


func _init() -> void:
	custom_minimum_size = Vector2(300, 0)
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_EXPAND_FILL

	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.08, 0.1, 0.9)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var main_vbox := VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 8)
	margin.add_child(main_vbox)

	var title := Label.new()
	title.text = "Equipamiento"
	title.add_theme_font_size_override("font_size", 16)
	main_vbox.add_child(title)

	_build_equipment_area(main_vbox)
	_build_unequip_button(main_vbox)
	_build_stats_panel(main_vbox)


func _build_equipment_area(parent: Control) -> void:
	var equip_grid := GridContainer.new()
	equip_grid.columns = 3
	equip_grid.add_theme_constant_override("h_separation", 8)
	equip_grid.add_theme_constant_override("v_separation", 8)
	equip_grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	parent.add_child(equip_grid)

	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.WEAPON)
	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.HELMET)
	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.ARMOR)

	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.BOOTS)
	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.GLOVES)
	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.BELT)

	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.RING)
	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.NECKLACE)
	_add_equip_slot(equip_grid, EquipmentItem.EquipmentSlot.EARRING)


func _add_equip_slot(
	parent: Control,
	slot_type: EquipmentItem.EquipmentSlot
) -> void:
	var container := VBoxContainer.new()
	container.add_theme_constant_override("separation", 2)
	container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	parent.add_child(container)

	var slot_label := Label.new()
	slot_label.text = SLOT_LABELS.get(slot_type, "")
	slot_label.add_theme_font_size_override("font_size", 10)
	slot_label.add_theme_color_override(
		"font_color",
		Color(0.5, 0.5, 0.5)
	)
	slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(slot_label)

	var slot_ui := ItemSlotUI.new()
	slot_ui.slot_clicked.connect(_on_equip_slot_clicked)
	container.add_child(slot_ui)

	_equip_slots[slot_type] = slot_ui


func _build_unequip_button(parent: Control) -> void:
	_unequip_btn = Button.new()
	_unequip_btn.text = "Desequipar"
	_unequip_btn.visible = false
	_unequip_btn.pressed.connect(_on_unequip_pressed)
	parent.add_child(_unequip_btn)


func _build_stats_panel(parent: Control) -> void:
	var sep := HSeparator.new()
	parent.add_child(sep)

	var stats_title := Label.new()
	stats_title.text = "Stats"
	stats_title.add_theme_font_size_override("font_size", 14)
	parent.add_child(stats_title)

	var stats_grid := GridContainer.new()
	stats_grid.columns = 2
	stats_grid.add_theme_constant_override("h_separation", 12)
	stats_grid.add_theme_constant_override("v_separation", 2)
	parent.add_child(stats_grid)

	for stat_key in StatsComponent.STAT_DISPLAY_NAMES:
		var display_name: String = StatsComponent.STAT_DISPLAY_NAMES[stat_key]

		var name_lbl := Label.new()
		name_lbl.text = display_name
		name_lbl.add_theme_font_size_override("font_size", 11)
		name_lbl.add_theme_color_override(
			"font_color",
			Color(0.6, 0.6, 0.6)
		)
		stats_grid.add_child(name_lbl)

		var value_lbl := Label.new()
		value_lbl.text = "0"
		value_lbl.add_theme_font_size_override("font_size", 11)
		value_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		stats_grid.add_child(value_lbl)

		_stats_labels[stat_key] = value_lbl


func setup(
	equipment: EquipmentComponent,
	stats: StatsComponent
) -> void:
	if equipment == null:
		return

	if _equipment != null:
		if _equipment.equipment_changed.is_connected(_refresh):
			_equipment.equipment_changed.disconnect(_refresh)

	_equipment = equipment
	_stats = stats

	_equipment.equipment_changed.connect(_refresh)

	_refresh()


func _refresh() -> void:
	if _equipment == null:
		return

	_refresh_equipment_slots()
	_refresh_stats()
	_refresh_selection()


func _refresh_equipment_slots() -> void:
	for slot_type in _equip_slots:
		var slot_ui: ItemSlotUI = _equip_slots[slot_type]
		var item: EquipmentItem = _equipment.get_equipped(slot_type)

		slot_ui.set_item(item)


func _refresh_stats() -> void:
	if _stats == null:
		return

	var equip_modifiers: Dictionary[StatsComponent.Stat, float] = \
	 _equipment.get_stat_modifiers()

	for stat_key in _stats_labels:
		var value_lbl: Label = _stats_labels[stat_key]

		var base_val: float = _stats.get_base_stat(stat_key)
		var mod_val: float = equip_modifiers.get(stat_key, 0.0)
		var total := base_val + mod_val

		if total == int(total):
			value_lbl.text = str(int(total))
		else:
			value_lbl.text = "%.1f" % total

		if mod_val > 0:
			value_lbl.add_theme_color_override(
				"font_color",
				Color(0.3, 0.9, 0.3)
			)
		elif mod_val < 0:
			value_lbl.add_theme_color_override(
				"font_color",
				Color(0.9, 0.3, 0.3)
			)
		else:
			value_lbl.add_theme_color_override(
				"font_color",
				Color.WHITE
			)


func _refresh_selection() -> void:
	if _selected_slot_type == -1:
		_unequip_btn.visible = false
		return

	if _equipment.is_slot_empty(_selected_slot_type):
		_selected_slot_type = -1
		_unequip_btn.visible = false
		return

	_unequip_btn.visible = true


func _on_equip_slot_clicked(slot_ui: ItemSlotUI) -> void:
	for slot_type in _equip_slots:
		if _equip_slots[slot_type] == slot_ui:
			_select_slot(slot_type)
			return


func _select_slot(slot_type: EquipmentItem.EquipmentSlot) -> void:
	if _equipment == null:
		return

	if _equipment.is_slot_empty(slot_type):
		_selected_slot_type = -1
		_unequip_btn.visible = false
		return

	_selected_slot_type = slot_type
	_unequip_btn.visible = true


func _on_unequip_pressed() -> void:
	if _selected_slot_type == -1:
		return

	var slot := _selected_slot_type

	_selected_slot_type = -1
	_unequip_btn.visible = false

	unequip_pressed.emit(slot)
