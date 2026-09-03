@tool
extends PanelContainer

enum IconColor { BLUE, GREEN, ORANGE, PURPLE }

@export var title_text: String = "标题":
	set(value):
		title_text = value
		if _ready_called:
			_title_label.text = value

@export var value_text: String = "0":
	set(value):
		value_text = value
		if _ready_called:
			_value_label.text = value

@export var unit_text: String = "":
	set(value):
		unit_text = value
		if _ready_called:
			_unit_label.text = value

@export var icon_hex: String = "F8FE":
	set(value):
		icon_hex = value
		if _ready_called:
			_icon_label.set("icon_name", value)

@export var icon_color: IconColor = IconColor.BLUE:
	set(value):
		icon_color = value
		if _ready_called:
			_apply_icon_color()

var _ready_called := false

@onready var _icon_panel: PanelContainer = $MarginContainer/HBoxContainer/Icon
@onready var _icon_label: Label = $MarginContainer/HBoxContainer/Icon/IconLabel
@onready var _title_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var _value_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/ValueBox/Value
@onready var _unit_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/ValueBox/Unit


func _ready() -> void:
	_title_label.text = title_text
	_value_label.text = value_text
	_unit_label.text = unit_text
	_icon_label.set("icon_name", icon_hex)
	_apply_icon_color()
	_ready_called = true


func _apply_icon_color() -> void:
	match icon_color:
		IconColor.BLUE:
			_icon_panel.theme_type_variation = &"StatsCardIconBgBlue"
		IconColor.GREEN:
			_icon_panel.theme_type_variation = &"StatsCardIconBgGreen"
		IconColor.ORANGE:
			_icon_panel.theme_type_variation = &"StatsCardIconBgOrange"
		IconColor.PURPLE:
			_icon_panel.theme_type_variation = &"StatsCardIconBgPurple"
