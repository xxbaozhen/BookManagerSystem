@tool
class_name BooleanTableCell
extends TableCell


const TRUE_LIST: Array[String] = ["True", "true", "T", "t", "1", "1.0"]
const FALSE_LIST: Array[String] = ["False", "false", "F", "f", "0", "0.0"]



var _icon_boolean: bool = false


func get_content_control() -> Control:
	return %ContentTextureRect


func set_content(new_content: Variant) -> void:
	var boolean: bool = false
	var is_visible: bool = true
	if new_content is bool:
		boolean = new_content
	elif new_content is int:
		boolean = false if new_content == 0 else true
	elif new_content is float:
		boolean = false if new_content == 0.0 else true
	elif new_content is String:
		if new_content in TRUE_LIST:
			boolean = true
		elif new_content in FALSE_LIST:
			boolean = false
		else:
			is_visible = false
	else:
		is_visible = false
	self._icon_boolean = boolean
	content = new_content
	%ContentTextureRect.visible = is_visible


func set_horizontal_alignment(alignment: HorizontalAlignment) -> void:
	match alignment:
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT:
			%ContentTextureRect.size_flags_horizontal = SIZE_SHRINK_BEGIN
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER:
			%ContentTextureRect.size_flags_horizontal = SIZE_SHRINK_CENTER
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT:
			%ContentTextureRect.size_flags_horizontal = SIZE_SHRINK_END


func set_vertical_alignment(alignment: VerticalAlignment) -> void:
	pass


func apply_other_config(root: TableRoot) -> void:
	super.apply_other_config(root)


func update_theme(theme: TablePlusTheme) -> void:
	super.update_theme(theme)
	
	if _icon_boolean:
		if theme != null and theme.boolean_cell_true_icon != null:
			%ContentTextureRect.texture = theme.boolean_cell_true_icon
		else:
			%ContentTextureRect.texture = load("res://addons/table_plus/icons/true.svg")
	else:
		if theme != null and theme.boolean_cell_false_icon != null:
			%ContentTextureRect.texture = theme.boolean_cell_false_icon
		else:
			%ContentTextureRect.texture = load("res://addons/table_plus/icons/false.svg")

	var boolean_cell_background_stylebox: StyleBox = theme.row_cell_background_stylebox
	if theme.boolean_cell_background_stylebox != null and not theme.boolean_cell_background_stylebox is StyleBoxEmpty:
		boolean_cell_background_stylebox = theme.boolean_cell_background_stylebox
	self.add_theme_stylebox_override("panel", boolean_cell_background_stylebox)


func compare_values(value_a: Variant, value_b: Variant, sort_state: TableGlobals.SortState) -> bool:
	var bool_a: bool = false
	var bool_b: bool = false
	var is_bool_a: bool = false
	var is_bool_b: bool = false

	if value_a is bool:
		bool_a = value_a
		is_bool_a = true
	elif value_a is int:
		bool_a = false if value_a == 0 else true
		is_bool_a = true
	elif value_a is float:
		bool_a = false if value_a == 0.0 else true
		is_bool_a = true
	elif value_a is String:
		if value_a in TRUE_LIST:
			bool_a = true
			is_bool_a = true
		elif value_a in FALSE_LIST:
			bool_a = false
			is_bool_a = true

	if value_b is bool:
		bool_b = value_b
		is_bool_b = true
	elif value_b is int:
		bool_b = false if value_b == 0 else true
		is_bool_b = true
	elif value_b is float:
		bool_b = false if value_b == 0.0 else true
		is_bool_b = true
	elif value_b is String:
		if value_b in TRUE_LIST:
			bool_b = true
			is_bool_b = true
		elif value_b in FALSE_LIST:
			bool_b = false
			is_bool_b = true

	# 如果一侧是布尔且另一侧不是，则布尔排在上面（无论升序或降序）
	if is_bool_a and not is_bool_b:
		return true
	if not is_bool_a and is_bool_b:
		return false

	# 若两侧都是布尔，则按升降序比较
	if is_bool_a and is_bool_b:
		match sort_state:
			TableGlobals.SortState.ASC:
				return bool_a < bool_b
			TableGlobals.SortState.DESC:
				return bool_a > bool_b
			_:
				return false

	# 两侧都不是布尔，保持不排序（返回 false）
	return false


func _handle_overflow() -> void:
	pass


func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	var boolean_cell_hover_background_stylebox: StyleBox = self._current_theme.row_cell_hover_background_stylebox
	if self._current_theme.boolean_cell_hover_background_stylebox != null and not self._current_theme.boolean_cell_hover_background_stylebox is StyleBoxEmpty:
		boolean_cell_hover_background_stylebox = self._current_theme.boolean_cell_hover_background_stylebox
	self.add_theme_stylebox_override("panel", boolean_cell_hover_background_stylebox)


func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	var boolean_cell_background_stylebox: StyleBox = self._current_theme.row_cell_background_stylebox
	if self._current_theme.boolean_cell_background_stylebox != null and not self._current_theme.boolean_cell_background_stylebox is StyleBoxEmpty:
		boolean_cell_background_stylebox = self._current_theme.boolean_cell_background_stylebox
	self.add_theme_stylebox_override("panel", boolean_cell_background_stylebox)
