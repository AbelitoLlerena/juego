class_name InventoryPanelUI
extends PanelContainer

signal slot_selected(slot_data: InventorySlot)
signal equip_pressed(item: ItemDefinition)
signal use_pressed(item: ItemDefinition)
signal drop_pressed(item: ItemDefinition)

var _inventory: InventoryComponent = null
var _grid: GridContainer
var _weight_label: Label
var _equip_btn: Button
var _use_btn: Button
var _drop_btn: Button
var _actions_bar: HBoxContainer
var _selected_slot: InventorySlot = null

const COLUMNS := 6
const GRID_SIZE := Vector2(280, 300)

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

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	margin.add_child(vbox)

	var header := HBoxContainer.new()
	vbox.add_child(header)

	var title := Label.new()
	title.text = "Inventario"
	title.add_theme_font_size_override("font_size", 16)
	header.add_child(title)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)

	_weight_label = Label.new()
	_weight_label.add_theme_font_size_override("font_size", 11)
	_weight_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	header.add_child(_weight_label)

	_grid = GridContainer.new()
	_grid.columns = COLUMNS
	_grid.add_theme_constant_override("h_separation", 4)
	_grid.add_theme_constant_override("v_separation", 4)
	_grid.custom_minimum_size = GRID_SIZE
	vbox.add_child(_grid)

	_actions_bar = HBoxContainer.new()
	_actions_bar.add_theme_constant_override("separation", 6)
	vbox.add_child(_actions_bar)

	_equip_btn = Button.new()
	_equip_btn.text = "Equipar"
	_equip_btn.visible = false
	_equip_btn.pressed.connect(_on_equip_pressed)
	_actions_bar.add_child(_equip_btn)

	_use_btn = Button.new()
	_use_btn.text = "Usar"
	_use_btn.visible = false
	_use_btn.pressed.connect(_on_use_pressed)
	_actions_bar.add_child(_use_btn)

	_drop_btn = Button.new()
	_drop_btn.text = "Soltar"
	_drop_btn.visible = false
	_drop_btn.pressed.connect(_on_drop_pressed)
	_actions_bar.add_child(_drop_btn)

func setup(inventory: InventoryComponent) -> void:
	if _inventory != null:
		if _inventory.inventory_changed.is_connected(_refresh):
			_inventory.inventory_changed.disconnect(_refresh)
		if _inventory.item_added.is_connected(_on_item_added):
			_inventory.item_added.disconnect(_on_item_added)
		if _inventory.item_removed.is_connected(_on_item_removed):
			_inventory.item_removed.disconnect(_on_item_removed)

	_inventory = inventory
	_inventory.inventory_changed.connect(_refresh)
	_inventory.item_added.connect(_on_item_added)
	_inventory.item_removed.connect(_on_item_removed)
	_refresh()

func _refresh() -> void:
	for child in _grid.get_children():
		child.queue_free()

	if _inventory == null:
		return

	for slot in _inventory.items:
		var slot_ui := ItemSlotUI.new()
		slot_ui.setup(slot)
		slot_ui.slot_clicked.connect(_on_slot_clicked)
		slot_ui.slot_hovered.connect(_on_slot_hovered)
		slot_ui.slot_unhovered.connect(_on_slot_unhovered)
		_grid.add_child(slot_ui)

	var empty_count := _inventory.capacity - _inventory.items.size()
	for _i in range(empty_count):
		var empty_slot_ui := ItemSlotUI.new()
		empty_slot_ui.setup_empty(ItemDefinition.SlotType.NONE)
		_grid.add_child(empty_slot_ui)

	_weight_label.text = "Peso: %.1f" % _inventory.get_total_weight()
	_update_actions()

func _on_slot_clicked(slot_ui: ItemSlotUI) -> void:
	for child in _grid.get_children():
		if child is ItemSlotUI:
			child.set_highlighted(false)

	slot_ui.set_highlighted(true)
	_selected_slot = slot_ui.get_slot_data()
	_update_actions()
	slot_selected.emit(_selected_slot)

func _on_slot_hovered(slot_ui: ItemSlotUI) -> void:
	pass

func _on_slot_unhovered(_slot_ui: ItemSlotUI) -> void:
	pass

func _on_item_added(_item: ItemDefinition, _qty: int) -> void:
	_refresh()

func _on_item_removed(_item: ItemDefinition, _qty: int) -> void:
	_refresh()

func _update_actions() -> void:
	if _selected_slot == null or _selected_slot.item == null:
		_equip_btn.visible = false
		_use_btn.visible = false
		_drop_btn.visible = false
		return

	var item := _selected_slot.item
	_equip_btn.visible = item.is_equipment()
	_use_btn.visible = item.is_consumable()
	_drop_btn.visible = true

func _on_equip_pressed() -> void:
	if _selected_slot != null and _selected_slot.item != null:
		equip_pressed.emit(_selected_slot.item)

func _on_use_pressed() -> void:
	if _selected_slot != null and _selected_slot.item != null:
		use_pressed.emit(_selected_slot.item)

func _on_drop_pressed() -> void:
	if _selected_slot != null and _selected_slot.item != null:
		drop_pressed.emit(_selected_slot.item)
