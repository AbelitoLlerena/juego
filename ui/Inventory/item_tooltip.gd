class_name ItemTooltipUI
extends PanelContainer

var _name_label: Label
var _type_label: Label
var _description_label: Label
var _stats_container: VBoxContainer
var _weight_label: Label

var RARITY_NAMES := {
	ItemDefinition.Rarity.COMMON: "Comun",
	ItemDefinition.Rarity.UNCOMMON: "Poco comun",
	ItemDefinition.Rarity.RARE: "Raro",
	ItemDefinition.Rarity.EPIC: "Epico",
	ItemDefinition.Rarity.LEGENDARY: "Legendaria",
}

var SLOT_TYPE_NAMES := {
	ItemDefinition.SlotType.NONE: "",
	ItemDefinition.SlotType.WEAPON: "Arma",
	ItemDefinition.SlotType.HELMET: "Casco",
	ItemDefinition.SlotType.ARMOR: "Armadura",
	ItemDefinition.SlotType.BOOTS: "Botas",
	ItemDefinition.SlotType.GLOVES: "Guantes",
	ItemDefinition.SlotType.ACCESSORY: "Accesorio",
}

const STAT_NAMES := {
	"strength": "Fuerza",
	"agility": "Agilidad",
	"intelligence": "Inteligencia",
	"constitution": "Constitucion",
	"base_physical_damage": "Daño fisico",
	"base_magical_damage": "Daño magico",
	"true_damage": "Daño verdadero",
	"crit_chance": "Chan. critico",
	"crit_bonus": "Bonus critico",
	"precision": "Precision",
	"armor_penetration": "Pen. armadura",
	"magic_penetration": "Pen. magica",
	"crit_multiplier": "Mult. critico",
	"life_steal": "Robo de vida",
	"energy_steal": "Robo de energia",
	"counterattack_chance": "Chan. contraataque",
	"combo_chance": "Chan. combo",
	"combo_damage": "Daño combo",
	"armor": "Armadura",
	"block_chance": "Chan. bloqueo",
	"dodge_chance": "Chan. esquiva",
	"damage_reflection": "Reflejo de daño",
	"tenacity": "Tenacidad",
	"damage_reduction": "Reduccion de daño",
	"health_restoration": "Regen. vida",
	"healing_efficiency": "Eficiencia curacion",
	"energy_regeneration": "Regen. energia",
}

func _init() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size = Vector2(0, 0)

	var bg := ColorRect.new()
	bg.color = Color(0.15, 0.15, 0.18, 0.95)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
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
	_type_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
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
	_weight_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	vbox.add_child(_weight_label)

func show_for(item: ItemDefinition) -> void:
	if item == null:
		hide()
		return

	_name_label.text = item.name
	var rarity_name: String = RARITY_NAMES.get(item.rarity, "")
	var rarity_color: Color = ItemSlotUI.RARITY_COLORS.get(item.rarity, Color.WHITE)
	_name_label.add_theme_color_override("font_color", rarity_color)

	var type_text := ""
	if item.item_type == ItemDefinition.ItemType.EQUIPMENT:
		type_text = SLOT_TYPE_NAMES.get(item.slot_type, "Equipo")
	elif item.item_type == ItemDefinition.ItemType.CONSUMABLE:
		type_text = "Consumible"
	elif item.item_type == ItemDefinition.ItemType.MATERIAL:
		type_text = "Material"
	if rarity_name != "":
		type_text += " - " + rarity_name
	_type_label.text = type_text

	_description_label.text = item.description if item.description != "" else ""

	for child in _stats_container.get_children():
		child.queue_free()

	for stat_name in item.stats:
		var value: float = item.stats[stat_name]
		if value == 0:
			continue
		var stat_label := Label.new()
		stat_label.add_theme_font_size_override("font_size", 11)
		var display_name: String = STAT_NAMES.get(stat_name, stat_name)
		var prefix := "+" if value > 0 else ""
		stat_label.text = "%s %s%s" % [display_name, prefix, str(value)]
		if value > 0:
			stat_label.add_theme_color_override("font_color", Color(0.3, 1.0, 0.3))
		else:
			stat_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))
		_stats_container.add_child(stat_label)

	if item.use_action != &"":
		var action_label := Label.new()
		action_label.add_theme_font_size_override("font_size", 11)
		action_label.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
		var action_text := ""
		match item.use_action:
			&"heal":
				action_text = "Cura %d HP" % item.use_value
			&"restore_energy":
				action_text = "Restaura %d energia" % item.use_value
			&"revive":
				action_text = "Revive con %d HP" % item.use_value
			_:
				action_text = String(item.use_action)
		action_label.text = action_text
		_stats_container.add_child(action_label)

	_weight_label.text = "Peso: %.1f" % item.weight

	visible = true
