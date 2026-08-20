@tool
extends Node

enum state {
	Normal,
	Hover,
	Pressed, # 新增：按住状态
	Selected,
	Disabled
}

static var normal_flat: StyleBoxFlat
static var hover_flat: StyleBoxFlat
static var pressed_flat: StyleBoxFlat # 新增
static var selected_flat: StyleBoxFlat
static var disabled_flat: StyleBoxFlat

func _ready() -> void:
	normal_flat = _create_style(Color.TRANSPARENT)
	hover_flat = _create_style(Color("#F8FBFF"))
	# 新增：按住时的背景色，这里选了一个比 Hover 更明显的浅蓝色
	pressed_flat = _create_style(Color("#E1EFFF")) 
	selected_flat = _create_style(Color("#48bfff3b"))
	disabled_flat = _create_style(Color.TRANSPARENT)

func _create_style(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.corner_detail = 8
	return style
