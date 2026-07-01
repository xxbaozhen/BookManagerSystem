@tool

extends mMenuButton

func update_style() -> void:
	var color := Color("000000")
	# 状态判定
	match state:
		MenuButtonState.state.Normal:
			background.add_theme_stylebox_override("panel", MenuButtonState.normal_flat)
		MenuButtonState.state.Hover:
			background.add_theme_stylebox_override("panel", MenuButtonState.hover_flat)
			color = Color("red")
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
