@tool
class_name mMenuButton extends Control

@onready var background: Panel = $Background
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var icon: Label = $MarginContainer/HBoxContainer/IconLabel

var _icon_hex: String = ""

var is_disable: bool:
	get:
		return state == MenuButtonState.state.Disabled

@export var text: String = "测试文本":
	set(value):
		text = value
		if is_node_ready():
			label.text = value

@export var icon_hex: String:
	get: return _icon_hex
	set(value):
		_icon_hex = value
		if is_node_ready():
			_update_icon_display(_icon_hex)

@export var state := MenuButtonState.state.Normal:
	set(value):
		state = value
		if is_node_ready():
			update_style()

func _ready():
	label.text = text
	_update_icon_display(_icon_hex)
	update_style()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _update_icon_display(hex_val: String) -> void:
	if _is_hex_string(hex_val):
		var code = hex_val.hex_to_int()
		if code >= 0 and code <= 0x10FFFF:
			icon.text = char(code)
		else:
			icon.text = ""
	else:
		icon.text = ""

func _is_hex_string(input: String) -> bool:
	if input.is_empty(): return false
	var clean_str = input.trim_prefix("0x").trim_prefix("0X")
	if clean_str.is_empty(): return false
	
	for c in clean_str:
		if not (c in "0123456789abcdefABCDEF"):
			return false
	return true

func _on_mouse_entered() -> void:
	if is_disable: 
		return
	if state != MenuButtonState.state.Selected and state != MenuButtonState.state.Pressed:
		state = MenuButtonState.state.Hover

func _on_mouse_exited() -> void:
	if is_disable: 
		return
	# 增加判定：如果处于 Hover 或者 Pressed 时移出了鼠标，都退回 Normal
	if state == MenuButtonState.state.Hover or state == MenuButtonState.state.Pressed:
		state = MenuButtonState.state.Normal

func update_style() -> void:
	var color := Color("000000")
	# 状态判定
	match state:
		MenuButtonState.state.Normal:
			background.add_theme_stylebox_override("panel", MenuButtonState.normal_flat)
		MenuButtonState.state.Hover:
			background.add_theme_stylebox_override("panel", MenuButtonState.hover_flat)
			#color = Color("red")
		MenuButtonState.state.Pressed: # 新增：Pressed状态样式
			background.add_theme_stylebox_override("panel", MenuButtonState.pressed_flat)
			color = Color("053299ff") # 给按住时分配一个较深的蓝色字体
		MenuButtonState.state.Selected:
			background.add_theme_stylebox_override("panel", MenuButtonState.selected_flat)
			color = Color("0745cfff")
		MenuButtonState.state.Disabled:
			background.add_theme_stylebox_override("panel", MenuButtonState.Disabled_flat)
			color = Color("585858ff")
			mouse_default_cursor_shape = Control.CURSOR_ARROW
			
	# 指针重置
	if state != MenuButtonState.state.Disabled:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
	# 状态修改
	label.add_theme_color_override("font_color", color)
	
	icon.label_settings.font_color = color
