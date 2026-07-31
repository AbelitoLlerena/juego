class_name ContainerUI
extends CanvasLayer

signal closed

var _player_inventory: InventoryComponent = null
var _container_inventory: InventoryComponent = null
var _container_name: String = "Contenedor"

var _is_open: bool = false
var _overlay: ColorRect
var _player_panel: InventoryPanelUI
var _container_panel: InventoryPanelUI
var _container_title: Label
var _player_title: Label

var _selected_item: ItemDefinition = null
var _selected_from_player: bool = false

func _init() -> void:
	layer = 10
	visible = false

	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0.6)
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(_on_overlay_input)
	add_child(_overlay)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 30)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(vbox)

	var header := HBoxContainer.new()
	vbox.add_child(header)

	var close_btn := Button.new()
	close_btn.text = "Cerrar"
	close_btn.pressed.connect(close)
	header.add_child(close_btn)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(hbox)

	var container_col := VBoxContainer.new()
	container_col.add_theme_constant_override("separation", 4)
	hbox.add_child(container_col)

	_container_title = Label.new()
	_container_title.add_theme_font_size_override("font_size", 14)
	_container_title.add_theme_color_override("font_color", Color(1.0, 0.8, 0.3))
	container_col.add_child(_container_title)

	_container_panel = InventoryPanelUI.new()
	container_col.add_child(_container_panel)

	var transfer_col := VBoxContainer.new()
	transfer_col.add_theme_constant_override("separation", 8)
	transfer_col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_child(transfer_col)

	var spacer2 := Control.new()
	spacer2.size_flags_vertical = Control.SIZE_EXPAND_FILL
	transfer_col.add_child(spacer2)

	var transfer_to_player := Button.new()
	transfer_to_player.text = ">>"
	transfer_to_player.custom_minimum_size = Vector2(50, 30)
	transfer_to_player.pressed.connect(_on_transfer_to_player)
	transfer_col.add_child(transfer_to_player)

	var transfer_to_container := Button.new()
	transfer_to_container.text = "<<"
	transfer_to_container.custom_minimum_size = Vector2(50, 30)
	transfer_to_container.pressed.connect(_on_transfer_to_container)
	transfer_col.add_child(transfer_to_container)

	var spacer3 := Control.new()
	spacer3.size_flags_vertical = Control.SIZE_EXPAND_FILL
	transfer_col.add_child(spacer3)

	var player_col := VBoxContainer.new()
	player_col.add_theme_constant_override("separation", 4)
	hbox.add_child(player_col)

	_player_title = Label.new()
	_player_title.text = "Inventario"
	_player_title.add_theme_font_size_override("font_size", 14)
	_player_title.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
	player_col.add_child(_player_title)

	_player_panel = InventoryPanelUI.new()
	player_col.add_child(_player_panel)

	_player_panel.slot_selected.connect(_on_player_slot_selected)
	_container_panel.slot_selected.connect(_on_container_slot_selected)

func setup(player_inv: InventoryComponent, container_inv: InventoryComponent, pname: String = "Contenedor") -> void:
	_player_inventory = player_inv
	_container_inventory = container_inv
	_container_name = pname
	_container_title.text = _container_name
	_player_panel.setup(player_inv)
	_container_panel.setup(container_inv)

func open() -> void:
	_is_open = true
	visible = true

func close() -> void:
	_is_open = false
	visible = false
	_selected_item = null
	_selected_from_player = false
	closed.emit()

func is_open() -> bool:
	return _is_open

func _on_overlay_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			close()

func _on_player_slot_selected(slot_data: InventorySlot) -> void:
	_container_panel.deselect_all()
	_selected_from_player = true
	if slot_data != null and slot_data.item != null:
		_selected_item = slot_data.item
	else:
		_selected_item = null

func _on_container_slot_selected(slot_data: InventorySlot) -> void:
	_player_panel.deselect_all()
	_selected_from_player = false
	if slot_data != null and slot_data.item != null:
		_selected_item = slot_data.item
	else:
		_selected_item = null

func _on_transfer_to_container() -> void:
	if _player_inventory == null or _container_inventory == null:
		return
	if _selected_item == null:
		return
	if not _player_inventory.has_item(_selected_item.id, 1):
		return

	var remaining := _container_inventory.add_item(_selected_item, 1)
	if remaining == 0:
		_player_inventory.remove_item(_selected_item.id, 1)
		_selected_item = null

func _on_transfer_to_player() -> void:
	if _player_inventory == null or _container_inventory == null:
		return
	if _selected_item == null:
		return
	if not _container_inventory.has_item(_selected_item.id, 1):
		return

	var remaining := _player_inventory.add_item(_selected_item, 1)
	if remaining == 0:
		_container_inventory.remove_item(_selected_item.id, 1)
		_selected_item = null
