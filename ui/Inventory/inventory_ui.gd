class_name InventoryUI
extends CanvasLayer

var _being: Being = null
var _equip_system: EquipmentSystem
var _is_open: bool = false

var _overlay: ColorRect
var _panel_container: MarginContainer
var _inventory_panel: InventoryPanelUI
var _equipment_panel: EquipmentPanelUI

func _init() -> void:
	layer = 10
	visible = false

	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0.6)
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(_on_overlay_input)
	add_child(_overlay)

	_panel_container = MarginContainer.new()
	_panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel_container.add_theme_constant_override("margin_left", 40)
	_panel_container.add_theme_constant_override("margin_right", 40)
	_panel_container.add_theme_constant_override("margin_top", 30)
	_panel_container.add_theme_constant_override("margin_bottom", 30)
	_panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_panel_container)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_panel_container.add_child(hbox)

	_inventory_panel = InventoryPanelUI.new()
	hbox.add_child(_inventory_panel)

	_equipment_panel = EquipmentPanelUI.new()
	hbox.add_child(_equipment_panel)

	_equip_system = EquipmentSystem.new()
	add_child(_equip_system)

func setup(being: Being) -> void:
	_being = being
	_inventory_panel.setup(being.inventory)
	_equipment_panel.setup(being.equipment, being.stats)

	_inventory_panel.equip_pressed.connect(_on_equip_pressed)
	_inventory_panel.use_pressed.connect(_on_use_pressed)
	_inventory_panel.drop_pressed.connect(_on_drop_pressed)
	_equipment_panel.unequip_pressed.connect(_on_unequip_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _is_open:
			toggle()
			get_viewport().set_input_as_handled()
		return

	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and key_event.keycode == KEY_I:
			toggle()
			get_viewport().set_input_as_handled()

func toggle() -> void:
	_is_open = !_is_open
	visible = _is_open

func open() -> void:
	_is_open = true
	visible = true

func close() -> void:
	_is_open = false
	visible = false

func is_open() -> bool:
	return _is_open

func _on_overlay_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			toggle()

func _on_equip_pressed(item: ItemDefinition) -> void:
	if _being == null:
		return
	_equip_system.equip_item(_being, item)

func _on_use_pressed(item: ItemDefinition) -> void:
	if _being == null:
		return
	_equip_system.use_item(_being, item)

func _on_drop_pressed(item: ItemDefinition) -> void:
	if _being == null:
		return
	_equip_system.drop_item(_being, item, 1)

func _on_unequip_pressed(slot: EquipmentItem.EquipmentSlot) -> void:
	if _being == null:
		return
	_equip_system.unequip_item(_being, slot)
