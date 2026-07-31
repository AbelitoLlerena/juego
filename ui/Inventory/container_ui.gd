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
var _transfer_all_to_player_btn: Button
var _transfer_all_to_container_btn: Button
var _transfer_one_btn: Button
var _item_name_label: Label
var _item_count_label: Label

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

	var center_col := VBoxContainer.new()
	center_col.add_theme_constant_override("separation", 6)
	center_col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_child(center_col)

	var spacer_top := Control.new()
	spacer_top.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center_col.add_child(spacer_top)

	_item_name_label = Label.new()
	_item_name_label.add_theme_font_size_override("font_size", 11)
	_item_name_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	_item_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_item_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_item_name_label.custom_minimum_size = Vector2(100, 0)
	center_col.add_child(_item_name_label)

	_item_count_label = Label.new()
	_item_count_label.add_theme_font_size_override("font_size", 10)
	_item_count_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	_item_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	center_col.add_child(_item_count_label)

	_transfer_one_btn = Button.new()
	_transfer_one_btn.text = "Transferir"
	_transfer_one_btn.custom_minimum_size = Vector2(100, 30)
	_transfer_one_btn.visible = false
	_transfer_one_btn.pressed.connect(_on_transfer_one_pressed)
	center_col.add_child(_transfer_one_btn)

	var sep := HSeparator.new()
	center_col.add_child(sep)

	_transfer_all_to_player_btn = Button.new()
	_transfer_all_to_player_btn.text = ">> Todo"
	_transfer_all_to_player_btn.custom_minimum_size = Vector2(100, 30)
	_transfer_all_to_player_btn.pressed.connect(_transfer_all_to_player)
	center_col.add_child(_transfer_all_to_player_btn)

	_transfer_all_to_container_btn = Button.new()
	_transfer_all_to_container_btn.text = "<< Todo"
	_transfer_all_to_container_btn.custom_minimum_size = Vector2(100, 30)
	_transfer_all_to_container_btn.pressed.connect(_transfer_all_to_container)
	center_col.add_child(_transfer_all_to_container_btn)

	var spacer_bot := Control.new()
	spacer_bot.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center_col.add_child(spacer_bot)

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
	_player_panel.hide_actions()
	_container_panel.hide_actions()
	_clear_selection()

func open() -> void:
	_is_open = true
	visible = true

func close() -> void:
	_is_open = false
	visible = false
	_clear_selection()
	closed.emit()

func is_open() -> bool:
	return _is_open

func _clear_selection() -> void:
	_selected_item = null
	_selected_from_player = false
	_item_name_label.text = ""
	_item_count_label.text = ""
	_transfer_one_btn.visible = false

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
		_item_name_label.text = slot_data.item.name
		_item_count_label.text = "x%d" % slot_data.quantity
		_transfer_one_btn.text = "Transferir <<"
		_transfer_one_btn.visible = true
	else:
		_clear_selection()

func _on_container_slot_selected(slot_data: InventorySlot) -> void:
	_player_panel.deselect_all()
	_selected_from_player = false
	if slot_data != null and slot_data.item != null:
		_selected_item = slot_data.item
		_item_name_label.text = slot_data.item.name
		_item_count_label.text = "x%d" % slot_data.quantity
		_transfer_one_btn.text = ">> Transferir"
		_transfer_one_btn.visible = true
	else:
		_clear_selection()

func _on_transfer_one_pressed() -> void:
	if _selected_item == null:
		return
	if _selected_from_player:
		_transfer_one_to_container()
	else:
		_transfer_one_to_player()

func _transfer_one_to_player() -> void:
	if _player_inventory == null or _container_inventory == null:
		return
	if not _container_inventory.has_item(_selected_item.id, 1):
		return

	var remaining := _player_inventory.add_item(_selected_item, 1)
	if remaining == 0:
		_container_inventory.remove_item(_selected_item.id, 1)
		_clear_selection()

func _transfer_one_to_container() -> void:
	if _player_inventory == null or _container_inventory == null:
		return
	if not _player_inventory.has_item(_selected_item.id, 1):
		return

	var remaining := _container_inventory.add_item(_selected_item, 1)
	if remaining == 0:
		_player_inventory.remove_item(_selected_item.id, 1)
		_clear_selection()

func _transfer_all_to_player() -> void:
	if _player_inventory == null or _container_inventory == null:
		return

	var to_transfer: Array[InventorySlot] = []
	for slot in _container_inventory.items:
		if slot.item != null:
			to_transfer.append(slot)

	for slot in to_transfer:
		var qty := slot.quantity
		for _i in qty:
			if _container_inventory.has_item(slot.item.id, 1):
				var remaining := _player_inventory.add_item(slot.item, 1)
				if remaining == 0:
					_container_inventory.remove_item(slot.item.id, 1)

	_clear_selection()

func _transfer_all_to_container() -> void:
	if _player_inventory == null or _container_inventory == null:
		return

	var to_transfer: Array[InventorySlot] = []
	for slot in _player_inventory.items:
		if slot.item != null:
			to_transfer.append(slot)

	for slot in to_transfer:
		var qty := slot.quantity
		for _i in qty:
			if _player_inventory.has_item(slot.item.id, 1):
				var remaining := _container_inventory.add_item(slot.item, 1)
				if remaining == 0:
					_player_inventory.remove_item(slot.item.id, 1)

	_clear_selection()
