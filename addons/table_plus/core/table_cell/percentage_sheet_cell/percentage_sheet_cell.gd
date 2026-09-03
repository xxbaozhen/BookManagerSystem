@tool
class_name PercentageTableCell
extends TextTableCell


enum RoundMode {
	## 四舍五入
	ROUND,
	## 向下取整
	FLOOR,
	## 向上取整
	CEIL
}



var decimals: int = 0: set = set_decimals
var round_mode: RoundMode = RoundMode.ROUND: set = set_round_mode


func set_content(new_content: Variant) -> void:
	if not (new_content is int or new_content is float) and not (new_content is String and String(new_content).is_valid_float()):
		content = 0.0
		%ContentRichTextLabel.text = _format_percentage_number(0.0, self.decimals, self.round_mode)
		return
	content = new_content
	var raw_value: float = float(new_content)
	# 把小数（例如 0.1234）换算为百分比（12.34）再格式化
	var percentage_value: float = raw_value * 100.0
	var formatted: String = _format_percentage_number(percentage_value, self.decimals, self.round_mode)
	%ContentRichTextLabel.text = formatted


func apply_other_config(root: TableRoot) -> void:
	super.apply_other_config(root)
	self.decimals = root.percentage_cell_decimal_places
	self.round_mode = root.percentage_cell_round_mode


func update_theme(theme: TablePlusTheme) -> void:
	super.update_theme(theme)
	var percentage_cell_background_stylebox: StyleBox = theme.row_cell_background_stylebox
	if theme.percentage_cell_background_stylebox != null and not theme.percentage_cell_background_stylebox is StyleBoxEmpty:
		percentage_cell_background_stylebox = theme.percentage_cell_background_stylebox
	self.add_theme_stylebox_override("panel", percentage_cell_background_stylebox)


func compare_values(value_a: Variant, value_b: Variant, sort_state: TableGlobals.SortState) -> bool:
	var num_a: float = 0.0
	var num_b: float = 0.0
	if value_a is int or value_a is float:
		num_a = float(value_a)
	elif value_a is String and String(value_a).is_valid_float():
		num_a = float(value_a)
	if value_b is int or value_b is float:
		num_b = float(value_b)
	elif value_b is String and String(value_b).is_valid_float():
		num_b = float(value_b)
	match sort_state:
		TableGlobals.SortState.ASC:
			return num_a < num_b
		TableGlobals.SortState.DESC:
			return num_a > num_b
		_:
			return false


func set_decimals(new_decimals: int) -> void:
	decimals = new_decimals
	self.set_content(self.content)


func set_round_mode(new_mode: RoundMode) -> void:
	round_mode = new_mode
	self.set_content(self.content)


func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	var percentage_cell_hover_background_stylebox: StyleBox = self._current_theme.row_cell_hover_background_stylebox
	if self._current_theme.percentage_cell_hover_background_stylebox != null and not self._current_theme.percentage_cell_hover_background_stylebox is StyleBoxEmpty:
		percentage_cell_hover_background_stylebox = self._current_theme.percentage_cell_hover_background_stylebox
	self.add_theme_stylebox_override("panel", percentage_cell_hover_background_stylebox)


func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	var percentage_cell_background_stylebox: StyleBox = self._current_theme.row_cell_background_stylebox
	if self._current_theme.percentage_cell_background_stylebox != null and not self._current_theme.percentage_cell_background_stylebox is StyleBoxEmpty:
		percentage_cell_background_stylebox = self._current_theme.percentage_cell_background_stylebox
	self.add_theme_stylebox_override("panel", percentage_cell_background_stylebox)


func _format_percentage_number(value: float, decimals: int = 2, round_mode: RoundMode = RoundMode.ROUND) -> String:
	var factor: float = pow(10.0, decimals)
	var rounded_value: float = value
	match round_mode:
		RoundMode.ROUND:
			rounded_value = round(value * factor) / factor
		RoundMode.FLOOR:
			rounded_value = floor(value * factor) / factor
		RoundMode.CEIL:
			rounded_value = ceil(value * factor) / factor
	# 先格式化数字部分，再拼接百分号，避免使用 "%%" 在某些情况下出错
	var number_fmt: String = "%." + str(decimals) + "f"
	var number_str: String = String(number_fmt % rounded_value)
	return number_str + "%"
