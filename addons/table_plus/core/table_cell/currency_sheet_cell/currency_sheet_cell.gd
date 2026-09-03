@tool
class_name CurrencyTableCell
extends TextTableCell


## 舍入模式
enum RoundMode {
	## 四舍五入
	ROUND,
	## 向下取整
	FLOOR,
	## 向上取整
	CEIL,
}


var decimal_places: int = 0: set = set_decimal_places
var round_mode: RoundMode = RoundMode.ROUND: set = set_round_mode
var currency_symbol: String = "$": set = set_currency_symbol


func get_content_control() -> Control:
	return %ContentRichTextLabel


func set_content(new_content: Variant) -> void:
	if not (new_content is int or new_content is float) \
	and not (new_content is String and String(new_content).is_valid_float()):
		# content = 0.0
		%ContentRichTextLabel.text = self._format_currency_number(0.0, self.decimal_places, self.round_mode)
		return
	content = new_content
	var format_currency = self._format_currency_number(float(content), self.decimal_places, self.round_mode)
	%ContentRichTextLabel.text = self.currency_symbol + format_currency


func apply_other_config(root: TableRoot) -> void:
	super.apply_other_config(root)
	self.decimal_places = root.currency_cell_decimal_places
	self.round_mode = root.currency_cell_round_mode
	self.currency_symbol = root.currency_cell_currency_symbol


func update_theme(theme: TablePlusTheme) -> void:
	super.update_theme(theme)
	var currency_cell_background_stylebox: StyleBox = theme.row_cell_background_stylebox
	if theme.currency_cell_background_stylebox != null and not theme.currency_cell_background_stylebox is StyleBoxEmpty:
		currency_cell_background_stylebox = theme.currency_cell_background_stylebox
	self.add_theme_stylebox_override("panel", currency_cell_background_stylebox)


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


func set_decimal_places(places: int) -> void:
	decimal_places = places
	self.set_content(self.content)


func set_round_mode(mode: RoundMode) -> void:
	round_mode = mode
	self.set_content(self.content)


func set_currency_symbol(symbol: String) -> void:
	currency_symbol = symbol
	self.set_content(self.content)


func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	var currency_cell_hover_background_stylebox: StyleBox = self._current_theme.row_cell_hover_background_stylebox
	if self._current_theme.currency_cell_hover_background_stylebox != null and not self._current_theme.currency_cell_hover_background_stylebox is StyleBoxEmpty:
		currency_cell_hover_background_stylebox = self._current_theme.currency_cell_hover_background_stylebox
	self.add_theme_stylebox_override("panel", currency_cell_hover_background_stylebox)


func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	var currency_cell_background_stylebox: StyleBox = self._current_theme.row_cell_background_stylebox
	if self._current_theme.currency_cell_background_stylebox != null and not self._current_theme.currency_cell_background_stylebox is StyleBoxEmpty:
		currency_cell_background_stylebox = self._current_theme.currency_cell_background_stylebox
	self.add_theme_stylebox_override("panel", currency_cell_background_stylebox)


func _format_currency_number(
	number: float,
	decimal_places: int = 0,
	round_mode: RoundMode = RoundMode.ROUND
) -> String:
	# 处理小数位数和四舍五入
	var processed_number: float = number
	if decimal_places >= 0:
		match round_mode:
			RoundMode.ROUND: # 四舍五入
				processed_number = round(number * pow(10, decimal_places)) / pow(10, decimal_places)
			RoundMode.FLOOR: # 向下取整
				processed_number = floor(number * pow(10, decimal_places)) / pow(10, decimal_places)
			RoundMode.CEIL: # 向上取整
				processed_number = ceil(number * pow(10, decimal_places)) / pow(10, decimal_places)
	else:
		processed_number = int(processed_number)
	# 将数字转换为字符串
	var num_str: String = str(processed_number)
	# 分割整数部分和小数部分
	var parts: PackedStringArray = num_str.split(".")
	var integer_part: String = parts[0]
	var decimal_part: String = ""
	# 新增：分离负号
	var sign_: String = ""
	if integer_part.begins_with("-"):
		sign_ = "-"
		integer_part = integer_part.substr(1)
	if parts.size() > 1:
		decimal_part = "." + parts[1]
		# 如果指定了小数位数但实际小数位数不足，补零
		if decimal_places >= 0 and parts[1].length() < decimal_places:
			decimal_part += "0".repeat(decimal_places - parts[1].length())
	elif decimal_places > 0:
		# 如果没有小数部分但需要显示小数位，添加小数点和零
		decimal_part = "." + "0".repeat(decimal_places)
	# 添加千位分隔符
	var formatted_integer: String = ""
	var count: int = 0
	for i in range(integer_part.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			formatted_integer = "," + formatted_integer
		formatted_integer = integer_part[i] + formatted_integer
		count += 1
	# 合并符号
	formatted_integer = sign_ + formatted_integer
	return formatted_integer + decimal_part
