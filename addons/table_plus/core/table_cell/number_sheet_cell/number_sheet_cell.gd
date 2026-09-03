@tool
class_name NumberTableCell
extends TextTableCell


## 分位类型
enum DelimiterType {
	## 无
	NONE,
	## 千分位
	THOUSAND,
	## 万分位
	TEN_THOUSAND,
}

## 舍入模式
enum RoundMode {
	## 四舍五入
	ROUND,
	## 向下取整
	FLOOR,
	## 向上取整
	CEIL
}


var decimals: int = 0: set = set_decimals
var delimiter_type: DelimiterType = DelimiterType.NONE: set = set_delimiter_type
var round_mode: RoundMode = RoundMode.ROUND: set = set_round_mode


func get_content_control() -> Control:
	return %ContentRichTextLabel


func set_content(new_content: Variant) -> void:
	if not (new_content is int or new_content is float) \
	and not (new_content is String and String(new_content).is_valid_float()):
		content = 0
		%ContentRichTextLabel.text = "0"
		return
	content = new_content
	%ContentRichTextLabel.text = self._format_number(float(content), decimals, delimiter_type, round_mode)


func apply_other_config(root: TableRoot) -> void:
	super.apply_other_config(root)
	self.decimals = root.number_cell_decimal_places
	self.delimiter_type = root.number_cell_delimiter_type
	self.round_mode = root.number_cell_round_mode


func update_theme(theme: TablePlusTheme) -> void:
	super.update_theme(theme)
	var number_cell_background_stylebox: StyleBox = theme.row_cell_background_stylebox
	if theme.number_cell_background_stylebox != null and not theme.number_cell_background_stylebox is StyleBoxEmpty:
		number_cell_background_stylebox = theme.number_cell_background_stylebox
	self.add_theme_stylebox_override("panel", number_cell_background_stylebox)


func compare_values(value_a: Variant, value_b: Variant, sort_state: TableGlobals.SortState) -> bool:
	var num_a: float = 0.0
	var num_b: float = 0.0

	if value_a is int:
		num_a = float(value_a)
	elif value_a is float:
		num_a = value_a
	elif value_a is String and String(value_a).is_valid_float():
		num_a = float(value_a)

	if value_b is int:
		num_b = float(value_b)
	elif value_b is float:
		num_b = value_b
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


func set_delimiter_type(new_type: DelimiterType) -> void:
	delimiter_type = new_type
	self.set_content(self.content)


func set_round_mode(new_mode: RoundMode) -> void:
	round_mode = new_mode
	self.set_content(self.content)


func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	var number_cell_hover_background_stylebox: StyleBox = self._current_theme.row_cell_hover_background_stylebox
	if self._current_theme.number_cell_hover_background_stylebox != null and not self._current_theme.number_cell_hover_background_stylebox is StyleBoxEmpty:
		number_cell_hover_background_stylebox = self._current_theme.number_cell_hover_background_stylebox
	self.add_theme_stylebox_override("panel", number_cell_hover_background_stylebox)


func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	var number_cell_background_stylebox: StyleBox = self._current_theme.row_cell_background_stylebox
	if self._current_theme.number_cell_background_stylebox != null and not self._current_theme.number_cell_background_stylebox is StyleBoxEmpty:
		number_cell_background_stylebox = self._current_theme.number_cell_background_stylebox
	self.add_theme_stylebox_override("panel", number_cell_background_stylebox)


func _format_number(
	value: float,
	decimals: int,
	delimiter_type: int = DelimiterType.NONE,
	round_mode: int = RoundMode.ROUND
) -> String:
	var num: float = value
	if decimals < 0:
		decimals = 0

	# 处理四舍五入/向上/向下（在取符号和格式化前处理）
	if decimals >= 0:
		var factor: float = pow(10, decimals)
		match round_mode:
			RoundMode.ROUND:
				num = round(num * factor) / factor
			RoundMode.FLOOR:
				num = floor(num * factor) / factor
			RoundMode.CEIL:
				num = ceil(num * factor) / factor

	var sign: String = ""
	if num < 0.0:
		sign = "-"
		num = -num

	var fmt: String = "%." + str(decimals) + "f"
	var num_str: String = fmt % num

	var parts: Array = num_str.split(".")
	var int_str: String = parts[0]
	var frac_str: String = ""
	if parts.size() > 1 and decimals > 0:
		frac_str = "." + parts[1]

	var group_size: int = 0
	if delimiter_type == DelimiterType.THOUSAND:
		group_size = 3
	elif delimiter_type == DelimiterType.TEN_THOUSAND:
		group_size = 4

	if group_size > 0:
		var res: String = ""
		var cnt: int = 0
		for i in range(int_str.length() - 1, -1, -1):
			res = int_str.substr(i, 1) + res
			cnt += 1
			if cnt % group_size == 0 and i != 0:
				res = "," + res
		int_str = res

	var result: String = sign + int_str + frac_str
	return result
