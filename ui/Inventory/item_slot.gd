class_name ItemSlotUI
extends PanelContainer

signal slot_clicked(slot_ui: ItemSlotUI)
signal slot_hovered(slot_ui: ItemSlotUI)
signal slot_unhovered(slot_ui: ItemSlotUI)

var _slot_data: InventorySlot = null
var _slot_type: ItemDefinition.SlotType = ItemDefinition.SlotType.NONE
var _is_highlighted: bool = false

var _icon: TextureRect
var _quantity_label: Label
var _rarity_border: ColorRect
var _bg: ColorRect

const SLOT_SIZE := Vector2(40, 40)
const EQUIP_SLOT_SIZE := Vector2(48, 48)

const RARITY_COLORS := {
	ItemDefinition.Rarity.COMMON: Color(0.6, 0.6, 0.6),
	ItemDefinition.Rarity.UNCOMMON: Color(0.2, 0.8, 0.2),
	ItemDefinition.Rarity.RARE: Color(0.3, 0.5, 1.0),
	ItemDefinition.Rarity.EPIC: Color(0.7, 0.3, 0.9),
	ItemDefinition.Rarity.LEGENDARY: Color(1.0, 0.7, 0.1),
}

func _init() -> void:
	custom_minimum_size = SLOT_SIZE
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_CENTER

	mouse_filter = Control.MOUSE_FILTER_STOP

	_bg = ColorRect.new()
	_bg.color = Color(0.12, 0.12, 0.15)
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg)

	_rarity_border = ColorRect.new()
	_rarity_border.color = Color.TRANSPARENT
	_rarity_border.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rarity_border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_rarity_border)

	_icon = TextureRect.new()
	_icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_icon)

	_quantity_label = Label.new()
	_quantity_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	_quantity_label.offset_left = -14
	_quantity_label.offset_top = -12
	_quantity_label.offset_right = -2
	_quantity_label.offset_bottom = -2
	_quantity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_quantity_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_quantity_label.add_theme_font_size_override("font_size", 10)
	_quantity_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_quantity_label)

func setup(slot_data: InventorySlot, is_equip_slot: bool = false) -> void:
	_slot_data = slot_data
	if is_equip_slot:
		custom_minimum_size = EQUIP_SLOT_SIZE
	_refresh_visual()

func setup_empty(slot_type: ItemDefinition.SlotType) -> void:
	_slot_type = slot_type
	_slot_data = null
	_refresh_visual()

func set_slot_data(slot_data: InventorySlot) -> void:
	_slot_data = slot_data
	_refresh_visual()

func get_slot_data() -> InventorySlot:
	return _slot_data

func set_slot_type(slot_type: ItemDefinition.SlotType) -> void:
	_slot_type = slot_type

func get_slot_type() -> ItemDefinition.SlotType:
	return _slot_type

func set_highlighted(highlighted: bool) -> void:
	_is_highlighted = highlighted
	if highlighted:
		_bg.color = Color(0.25, 0.25, 0.3)
	else:
		_bg.color = Color(0.12, 0.12, 0.15)

func _refresh_visual() -> void:
	if _slot_data != null and _slot_data.item != null:
		var item := _slot_data.item
		_icon.texture = item.icon
		if _slot_data.quantity > 1:
			_quantity_label.text = str(_slot_data.quantity)
			_quantity_label.visible = true
		else:
			_quantity_label.visible = false
		_rarity_border.color = RARITY_COLORS.get(item.rarity, Color.WHITE)
		tooltip_text = item.name
	else:
		_icon.texture = null
		_quantity_label.visible = false
		_rarity_border.color = Color.TRANSPARENT
		tooltip_text = ""

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			slot_clicked.emit(self)

func _mouse_enter() -> void:
	slot_hovered.emit(self)

func _mouse_exit() -> void:
	slot_unhovered.emit(self)
