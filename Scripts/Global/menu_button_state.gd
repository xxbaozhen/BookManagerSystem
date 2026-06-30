@tool
extends Node

enum state {
	Normal,
	Hover,
	Selected,
	Disabled
}

static var normal_flat: StyleBoxFlat
static var hover_flat: StyleBoxFlat
static var selected_flat: StyleBoxFlat
static var Disabled_flat: StyleBoxFlat


func _ready() -> void:
	normal_flat = _create_style(
		Color.TRANSPARENT,
	)

	hover_flat = _create_style(
		Color("#F8FBFF"),
	)

	selected_flat = _create_style(
		Color("48bfff3b"),
	)

	Disabled_flat = _create_style(
		Color.TRANSPARENT,
	)


func _create_style(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	# 背景
	style.bg_color = bg

	# 圆角
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8

	# Corner Detail
	style.corner_detail = 8

	return style
