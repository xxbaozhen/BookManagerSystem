@tool
extends HBoxContainer

@export var label_text: String = "图例":
	set(value):
		label_text = value
		if _ready_called:
			_label.text = value

@export var dot_color: Color = Color(0.7, 0.72, 0.78, 1):
	set(value):
		dot_color = value
		if _ready_called:
			_apply_dot_color()

var _ready_called := false

@onready var _dot: PanelContainer = $ColorDot
@onready var _label: Label = $Label


func _ready() -> void:
	_label.text = label_text
	_apply_dot_color()
	_ready_called = true


func _apply_dot_color() -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = dot_color
	sb.corner_radius_top_left = 5
	sb.corner_radius_top_right = 5
	sb.corner_radius_bottom_right = 5
	sb.corner_radius_bottom_left = 5
	_dot.add_theme_stylebox_override("panel", sb)
