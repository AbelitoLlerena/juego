class_name CharacterPanelUI
extends CanvasLayer

var _being: Being = null
var _is_open: bool = false

var _overlay: ColorRect
var _name_label: Label
var _level_label: Label
var _xp_bar: ProgressBar
var _stats_grid: GridContainer
var _status_box: VBoxContainer

func _init() -> void:
	layer = 11
	visible = false

	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0.6)
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(_on_overlay_input)
	add_child(_overlay)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(420, 0)
	center.add_child(panel)

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.97)
	style.border_color = Color(0.3, 0.3, 0.4)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 20
	style.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", style)

	var main := VBoxContainer.new()
	main.add_theme_constant_override("separation", 10)
	panel.add_child(main)

	_name_label = Label.new()
	_name_label.add_theme_font_size_override("font_size", 22)
	_name_label.add_theme_color_override("font_color", Color.WHITE)
	_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main.add_child(_name_label)

	var xp_row := HBoxContainer.new()
	xp_row.add_theme_constant_override("separation", 12)
	main.add_child(xp_row)

	_level_label = Label.new()
	_level_label.add_theme_font_size_override("font_size", 15)
	_level_label.custom_minimum_size = Vector2(90, 0)
	xp_row.add_child(_level_label)

	_xp_bar = ProgressBar.new()
	_xp_bar.custom_minimum_size = Vector2(0, 20)
	_xp_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_xp_bar.show_percentage = false
	_xp_bar.max_value = 100
	xp_row.add_child(_xp_bar)

	main.add_child(_make_separator())

	var stats_title := _make_section_title("Estadísticas")
	main.add_child(stats_title)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 220)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main.add_child(scroll)

	_stats_grid = GridContainer.new()
	_stats_grid.columns = 2
	_stats_grid.add_theme_constant_override("h_separation", 30)
	_stats_grid.add_theme_constant_override("v_separation", 4)
	scroll.add_child(_stats_grid)

	main.add_child(_make_separator())

	var status_title := _make_section_title("Estados activos")
	main.add_child(status_title)

	_status_box = VBoxContainer.new()
	main.add_child(_status_box)

func _make_section_title(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
	return label

func _make_separator() -> HSeparator:
	var sep := HSeparator.new()
	sep.add_theme_stylebox_override("separator", StyleBoxLine.new())
	return sep

func _add_stat(name: String, value: String) -> void:
	var name_label := Label.new()
	name_label.text = name
	name_label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.85))
	_stats_grid.add_child(name_label)

	var value_label := Label.new()
	value_label.text = value
	value_label.add_theme_color_override("font_color", Color.WHITE)
	_stats_grid.add_child(value_label)

func setup(being: Being) -> void:
	_being = being
	_refresh()

func _refresh() -> void:
	if _being == null:
		return

	_name_label.text = _being.entity_name

	var exp := _being.experience
	_level_label.text = "Nivel %d" % exp.level
	_xp_bar.max_value = maxi(exp.experience_to_next_level, 1)
	_xp_bar.value = exp.experience

	for child in _stats_grid.get_children():
		child.free()

	var health := _being.health
	var stats := _being.stats
	var energy := _being.energy

	_add_stat("Salud", "%d / %d" % [health.health, health.max_health])
	_add_stat("Energía", "%d / %d" % [energy.energy, energy.max_energy])
	_add_stat("Fuerza", str(stats.strength))
	_add_stat("Agilidad", str(stats.agility))
	_add_stat("Inteligencia", str(stats.intelligence))
	_add_stat("Constitución", str(stats.constitution))
	_add_stat("Armadura", str(stats.armor))
	_add_stat("Escudo", str(stats.shield))
	_add_stat("Daño físico", str(stats.base_physical_damage))
	_add_stat("Daño mágico", str(stats.base_magical_damage))
	_add_stat("Alcance", str(stats.range))
	_add_stat("Moral", "%.0f%%" % (stats.morale * 100))
	_add_stat("Estrés", "%.0f%%" % (stats.stress * 100))
	_add_stat("Hambre", "%.0f%%" % (stats.hungry * 100))
	_add_stat("Sed", "%.0f%%" % (stats.thirst * 100))
	_add_stat("Dolor", "%.0f%%" % (stats.pain * 100))
	_add_stat("Fatiga", "%.0f%%" % (stats.fatigue * 100))

	for child in _status_box.get_children():
		child.free()

	var statuses := _being.status.get_active_statuses()
	if statuses.is_empty():
		var none := Label.new()
		none.text = "Ninguno"
		none.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		_status_box.add_child(none)
	else:
		for entry in statuses:
			var status_label := Label.new()
			status_label.text = "%s  (x%d, %d turnos)" % [
				StatusComponent.type_name(entry["type"]),
				entry["stacks"],
				entry["remaining_turns"]
			]
			status_label.add_theme_color_override("font_color", _status_color(entry["type"]))
			_status_box.add_child(status_label)

func _status_color(type: int) -> Color:
	match type:
		StatusComponent.Type.POISON:
			return Color(0.4, 0.9, 0.4)
		StatusComponent.Type.BURN:
			return Color(1.0, 0.5, 0.2)
		StatusComponent.Type.SLOWED:
			return Color(0.5, 0.7, 1.0)
	return Color.WHITE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _is_open:
			toggle()
			get_viewport().set_input_as_handled()
		return

	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and key_event.keycode == KEY_P:
			toggle()
			get_viewport().set_input_as_handled()

func toggle() -> void:
	_is_open = !_is_open
	visible = _is_open
	if _is_open:
		_refresh()

func open() -> void:
	_is_open = true
	visible = true
	_refresh()

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
