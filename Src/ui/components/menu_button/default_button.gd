@tool

extends mMenuButton

func update_style() -> void:
	super.update_style()
	# 仅悬停时文字变红，其余状态复用父类逻辑
	if state == MenuButtonState.state.Hover:
		label.add_theme_color_override("font_color", Color("#ff0000"))
		icon.label_settings.font_color = Color("#ff0000")
