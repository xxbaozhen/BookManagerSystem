@tool
class_name DateTableCell
extends TextTableCell

enum DateFormat {
	## 年-月-日 1970-12-31
	YYYY_MM_DD,
	## 日-月-年 31-12-1970
	DD_MM_YYYY,
	## 月-日-年 12-31-1970
	MM_DD_YYYY,
	## 年/月/日 1970/12/31
	YYYY_MM_DD_SLASH,
	## 月/日/年 12/31/1970
	MM_DD_YYYY_SLASH,
	## 日/月/年 31.12.1970
	DD_MM_YYYY_SLASH,
	## 年.月.日 1970.12.31
	YYYY_MM_DD_DOT,
	## 月.日.年 12.31.1970
	MM_DD_YYYY_DOT,
	## 日.月.年 31.12.1970
	DD_MM_YYYY_DOT,
}



var display_format: DateFormat = DateFormat.YYYY_MM_DD: set = set_display_format


func get_content_control() -> Control:
	return %ContentRichTextLabel


func set_content(new_content: Variant) -> void:
	if not (new_content is String):
		content = ""
		%ContentRichTextLabel.text = ""
		return
	content = new_content
	%ContentRichTextLabel.text = self._format_date_string(new_content, self.display_format)


func apply_other_config(root: TableRoot) -> void:
	super.apply_other_config(root)
	self.display_format = root.date_cell_display_format


func update_theme(theme: TablePlusTheme) -> void:
	super.update_theme(theme)
	var date_cell_background_stylebox: StyleBox = theme.row_cell_background_stylebox
	if theme.date_cell_background_stylebox != null and not theme.date_cell_background_stylebox is StyleBoxEmpty:
		date_cell_background_stylebox = theme.date_cell_background_stylebox
	self.add_theme_stylebox_override("panel", date_cell_background_stylebox)


func compare_values(value_a: Variant, value_b: Variant, sort_state: TableGlobals.SortState) -> bool:
	var date_str_a: String = str(value_a)
	var date_str_b: String = str(value_b)
	var formatted_a: String = self._format_date_string(date_str_a, DateFormat.YYYY_MM_DD)
	var formatted_b: String = self._format_date_string(date_str_b, DateFormat.YYYY_MM_DD)
	match sort_state:
		TableGlobals.SortState.ASC:
			return formatted_a < formatted_b
		TableGlobals.SortState.DESC:
			return formatted_a > formatted_b
		_:
			return false


func set_display_format(format: DateFormat) -> void:
	display_format = format
	self.set_content(self.content)


func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	var date_cell_hover_background_stylebox: StyleBox = self._current_theme.row_cell_hover_background_stylebox
	if self._current_theme.date_cell_hover_background_stylebox != null and not self._current_theme.date_cell_hover_background_stylebox is StyleBoxEmpty:
		date_cell_hover_background_stylebox = self._current_theme.date_cell_hover_background_stylebox
	self.add_theme_stylebox_override("panel", date_cell_hover_background_stylebox)


func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	var date_cell_background_stylebox: StyleBox = self._current_theme.row_cell_background_stylebox
	if self._current_theme.date_cell_background_stylebox != null and not self._current_theme.date_cell_background_stylebox is StyleBoxEmpty:
		date_cell_background_stylebox = self._current_theme.date_cell_background_stylebox
	self.add_theme_stylebox_override("panel", date_cell_background_stylebox)


func _format_date_string(date_str: String, target_format: int = DateFormat.YYYY_MM_DD, day_first: bool = true) -> String:
	if date_str == null:
		return ""
	var s: String = date_str.strip_edges()
	if s == "":
		return ""
	# 规范分隔符并移除时间部分
	s = s.replace('.', '-').replace('/', '-')
	if s.find(' ') != -1:
		s = s.split(' ')[0]
	if s.find('T') != -1:
		s = s.split('T')[0]
	# 处理紧凑格式 YYYYMMDD
	if s.length() == 8 and s.is_valid_int():
		var y: String = s.substr(0, 4)
		var m: String = s.substr(4, 2)
		var d: String = s.substr(6, 2)
		# 决定分隔符
		var sep: String = "-"
		if target_format in [DateFormat.YYYY_MM_DD_DOT, DateFormat.DD_MM_YYYY_DOT, DateFormat.MM_DD_YYYY_DOT]:
			sep = "."
		elif target_format in [DateFormat.YYYY_MM_DD_SLASH, DateFormat.MM_DD_YYYY_SLASH, DateFormat.DD_MM_YYYY_SLASH]:
			sep = "/"
		# 决定顺序（0=年-月-日, 1=日-月-年, 2=月-日-年）
		var order_type: int = 0
		if target_format in [DateFormat.YYYY_MM_DD, DateFormat.YYYY_MM_DD_SLASH, DateFormat.YYYY_MM_DD_DOT]:
			order_type = 0
		elif target_format in [DateFormat.DD_MM_YYYY, DateFormat.DD_MM_YYYY_DOT, DateFormat.DD_MM_YYYY_SLASH]:
			order_type = 1
		else:
			order_type = 2
		if sep == "":
			if order_type == 0:
				return "%s%s%s" % [y, m, d]
			elif order_type == 1:
				return "%s%s%s" % [d, m, y]
			else:
				return "%s%s%s" % [m, d, y]
		else:
			if order_type == 0:
				return "%s%s%s%s%s" % [y, sep, m, sep, d]
			elif order_type == 1:
				return "%s%s%s%s%s" % [d, sep, m, sep, y]
			else:
				return "%s%s%s%s%s" % [m, sep, d, sep, y]
	# 处理带分隔符的日期格式
	var parts: Array = s.split('-')
	if parts.size() == 3:
		var y: String = ""
		var m: String = ""
		var d: String = ""
		if parts[0].length() == 4:
			y = parts[0]
			m = parts[1]
			d = parts[2]
		else:
			if day_first:
				d = parts[0]
				m = parts[1]
				y = parts[2]
			else:
				m = parts[0]
				d = parts[1]
				y = parts[2]
		# 补零单字符的月/日
		if m.length() == 1:
			m = "0" + m
		if d.length() == 1:
			d = "0" + d
		# 确定输出分隔符
		var sep2: String = "-"
		if target_format in [DateFormat.YYYY_MM_DD_DOT, DateFormat.DD_MM_YYYY_DOT, DateFormat.MM_DD_YYYY_DOT]:
			sep2 = "."
		elif target_format in [DateFormat.YYYY_MM_DD_SLASH, DateFormat.MM_DD_YYYY_SLASH, DateFormat.DD_MM_YYYY_SLASH]:
			sep2 = "/"
		# 确定输出顺序
		var ord: int = 0
		if target_format in [DateFormat.YYYY_MM_DD, DateFormat.YYYY_MM_DD_SLASH, DateFormat.YYYY_MM_DD_DOT]:
			ord = 0
		elif target_format in [DateFormat.DD_MM_YYYY, DateFormat.DD_MM_YYYY_DOT, DateFormat.DD_MM_YYYY_SLASH]:
			ord = 1
		else:
			ord = 2
		if sep2 == "":
			if ord == 0:
				return "%s%s%s" % [y, m, d]
			elif ord == 1:
				return "%s%s%s" % [d, m, y]
			else:
				return "%s%s%s" % [m, d, y]
		else:
			if ord == 0:
				return "%s%s%s%s%s" % [y, sep2, m, sep2, d]
			elif ord == 1:
				return "%s%s%s%s%s" % [d, sep2, m, sep2, y]
			else:
				return "%s%s%s%s%s" % [m, sep2, d, sep2, y]
	# 失败时返回原始字符串
	return date_str
