@tool
extends Node

enum State {
	NORMAL,
	HOVER,
	PRESSED, # 新增：按住状态
	SELECTED,
	DISABLED
}

static var normal_flat: StyleBoxFlat
static var hover_flat: StyleBoxFlat
static var pressed_flat: StyleBoxFlat # 新增
static var selected_flat: StyleBoxFlat
static var disabled_flat: StyleBoxFlat

static var _styles_initialized := false

# 惰性初始化：样式在首次访问前确保已创建，不再依赖 autoload 的 _ready() 时序
static func ensure_styles() -> void:
	if _styles_initialized:
		return
	normal_flat = _create_style(Color.TRANSPARENT)
	hover_flat = _create_style(Color("#F8FBFF"))
	# 新增：按住时的背景色，这里选了一个比 Hover 更明显的浅蓝色
	pressed_flat = _create_style(Color("#E1EFFF"))
	selected_flat = _create_style(Color("#48bfff3b"))
	disabled_flat = _create_style(Color.TRANSPARENT)
	_styles_initialized = true

func _ready() -> void:
	ensure_styles()

static func _create_style(bg: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.corner_detail = 8
	return style
