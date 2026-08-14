class_name ItemSlotUI
extends PanelContainer

signal slot_clicked(slot_ui: ItemSlotUI)
signal slot_hovered(slot_ui: ItemSlotUI)
signal slot_unhovered(slot_ui: ItemSlotUI)

var _item: ItemDefinition = null
var _is_highlighted: bool = false

var _icon: TextureRect
var _quantity_label: Label
var _rarity_border: Panel


const SLOT_SIZE := Vector2(40, 40)

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

	var bg := ColorRect.new()
	bg.name = "Background"
	bg.color = Color(0.12, 0.12, 0.15)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	_rarity_border = Panel.new()
	_rarity_border.name = "RarityBorder"
	_rarity_border.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_rarity_border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_rarity_border)

	_icon = TextureRect.new()
	_icon.name = "Icon"
	_icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_icon)

	_quantity_label = Label.new()
	_quantity_label.name = "Quantity"
	_quantity_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	_quantity_label.offset_left = -14
	_quantity_label.offset_top = -12
	_quantity_label.offset_right = -2
	_quantity_label.offset_bottom = -2
	_quantity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_quantity_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_quantity_label.add_theme_font_size_override("font_size", 10)
	_quantity_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_quantity_label.visible = false
	add_child(_quantity_label)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	_refresh_visual()


func set_item(item: ItemDefinition) -> void:
	_item = item
	_refresh_visual()


func get_item() -> ItemDefinition:
	return _item


func clear_item() -> void:
	_item = null
	_refresh_visual()


func set_quantity(quantity: int) -> void:
	if _item == null or quantity <= 1:
		_quantity_label.visible = false
		return

	_quantity_label.text = str(quantity)
	_quantity_label.visible = true


func set_highlighted(highlighted: bool) -> void:
	_is_highlighted = highlighted
	_refresh_visual()


func is_empty() -> bool:
	return _item == null

func _refresh_visual() -> void:
	if _item == null:
		_icon.texture = null
		_quantity_label.visible = false
		_rarity_border.visible = false
		tooltip_text = ""
		_refresh_background()
		return

	_icon.texture = _item.icon
	_rarity_border.visible = true
	_set_rarity_border(_item.rarity)
	tooltip_text = _item.name

	_refresh_background()


func _refresh_background() -> void:
	var bg := get_node_or_null("Background") as ColorRect
	if bg == null:
		return

	if _is_highlighted:
		bg.color = Color(0.25, 0.25, 0.3)
	else:
		bg.color = Color(0.12, 0.12, 0.15)


func _set_rarity_border(rarity: ItemDefinition.Rarity) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color.TRANSPARENT
	style.border_color = RARITY_COLORS.get(rarity, Color.WHITE)

	style.set_border_width_all(2)
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2

	_rarity_border.add_theme_stylebox_override("panel", style)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton

		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			slot_clicked.emit(self)

func _on_mouse_entered() -> void:
	slot_hovered.emit(self)

func _on_mouse_exited() -> void:
	slot_unhovered.emit(self)
