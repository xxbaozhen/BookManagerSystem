@tool
class_name TableRoot
extends Control


signal row_clicked(row_index: int, row: TableRow)
signal row_mouse_entered(row_index: int, row: TableRow)
signal row_mouse_exited(row_index: int, row: TableRow)
signal cell_clicked(row_index: int, column_index: int, cell: TableCell)


## 滚动条可见性
enum ScrollbarVisibility {
	## 自动
	Auto,
	## 始终显示
	AlwaysShow,
	## 从不显示
	NeverShow
}

## 交互模式
enum InteractionMode {
	## 行
	Row,
	## 单元格
	Cell
}


const TABLE_ROW = preload("uid://c1x2b8pmjaeep")


## 内容
var data: Array[Array] = []: set = set_data


## 标题可见性
var title_visible: bool = true: set = set_title_visible
## 标题文本
var title_text: String = "Title": set = set_title_text
## 标题对齐方式
var title_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT: set = set_title_alignment
## 表头
var headers: Array[TableHeaderCellResource] = []: set = set_headers
## 表头高度
var header_height: float = 50.0: set = set_header_height
## 表头垂直分割线可见性
var headers_vertical_separator_visible: bool = true: set = set_headers_vertical_separator_visible
## 表头水平分割线可见性
var headers_horizontal_separator_visible: bool = true: set = set_headers_horizontal_separator_visible
## 表头水平分割线偏移
var headers_horizontal_separators_offset: float = 0.0: set = set_headers_horizontal_separators_offset

## 行高
var row_height: float = 50.0: set = set_row_height
## 行垂直分割线可见性
var rows_vertical_separators_visible: bool = true: set = set_rows_vertical_separators_visible
## 行水平分割线可见性
var rows_horizontal_separators_visible: bool = true: set = set_rows_horizontal_separators_visible
## 行水平分割线偏移
var rows_horizontal_separators_offset: float = 0.0: set = set_rows_horizontal_separators_offset

## 预览数据
var preview_data: Array[Array] = []: set = set_preview_data

## 数字单元格小数位数
var number_cell_decimal_places: int = 0: set = set_number_cell_decimal_places
## 数字单元格分位类型
var number_cell_delimiter_type: NumberTableCell.DelimiterType = NumberTableCell.DelimiterType.NONE: set = set_number_cell_delimiter_type
## 数字单元格舍入模式
var number_cell_round_mode: NumberTableCell.RoundMode = NumberTableCell.RoundMode.ROUND: set = set_number_cell_round_mode
## 货币单元格小数位数
var currency_cell_decimal_places: int = 2: set = set_currency_cell_decimal_places
## 货币单元格舍入模式
var currency_cell_round_mode: CurrencyTableCell.RoundMode = CurrencyTableCell.RoundMode.ROUND: set = set_currency_cell_round_mode
## 货币单元格货币符号
var currency_cell_currency_symbol: String = "$": set = set_currency_cell_currency_symbol
## 百分比单元格小数位数
var percentage_cell_decimal_places: int = 2: set = set_percentage_cell_decimal_places
## 百分比单元格舍入模式
var percentage_cell_round_mode: PercentageTableCell.RoundMode = PercentageTableCell.RoundMode.ROUND: set = set_percentage_cell_round_mode
## 日期单元格显示格式
var date_cell_display_format: DateTableCell.DateFormat = DateTableCell.DateFormat.YYYY_MM_DD: set = set_date_cell_display_format
## 进度条单元格填充模式
var progress_cell_fill_mode: ProgressBar.FillMode = ProgressBar.FillMode.FILL_BEGIN_TO_END: set = set_progress_cell_fill_mode
## 进度条单元格显示百分比
var progress_cell_show_percentage: bool = true: set = set_progress_cell_show_percentage

## 滚动条可见性
var scroll_bar_visible: ScrollbarVisibility = ScrollbarVisibility.Auto: set = set_scroll_bar_visible
## 滚动条自定义步长
var scroll_bar_custom_step: float = 10.0: set = set_scroll_bar_custom_step

## 标题与表头间距
var title_header_separation: float = 0.0: set = set_title_header_separation
## 表头行间距
var header_rows_separation: float = 0.0: set = set_header_rows_separation
## 内容与滚动条间距
var content_scroll_bar_separation: float = 0.0: set = set_content_scroll_bar_separation
## 行间距
var line_spacing: float = 0.0: set = set_line_spacing

## 交互模式
var interaction_mode: InteractionMode = InteractionMode.Row: set = set_interaction_mode

var _current_theme: TablePlusTheme = null


func _ready() -> void:
	self.gui_input.connect(self._on_gui_input)
	self.resized.connect(self._on_resized)
	%RowsVBoxContainer.resized.connect(self._on_resized)
	%TableHeader.header_cell_sorted.connect(self._on_header_cell_sorted)
	%OuterVScrollBar.value_changed.connect(self._on_scroll_bar_value_changed)


func set_data(new_data: Array[Array]) -> void:
	if Engine.is_editor_hint():
		return
	data = new_data
	self._update_rows()
	

func set_resize(new_size: Vector2) -> void:
	self.size = new_size


func set_title_visible(visible: bool) -> void:
	title_visible = visible
	%TitleLabel.visible = visible


func set_title_text(name: String) -> void:
	title_text = name
	%TitleLabel.text = title_text


func set_title_alignment(alignment: HorizontalAlignment) -> void:
	title_alignment = alignment
	%TitleLabel.horizontal_alignment = alignment


func set_headers(new_headers: Array[TableHeaderCellResource]) -> void:
	headers = new_headers
	%TableHeader.clear_cells()
	# var index: int = 0
	var id_set: Array[String] = []
	for header_resource: TableHeaderCellResource in self.headers:
		if header_resource == null:
			continue
		
		if id_set.has(header_resource.id):
			push_error("Duplicate header cell ID found: ", header_resource.id)
		else:
			id_set.append(header_resource.id)
		
		%TableHeader.add_cell(header_resource)
		# for row: TableRow in %RowsVBoxContainer.get_children():
		# 	var cells: Array[TableCell] = row.get_cells()
		# 	if index >= cells.size():
		# 		continue
		# 	cells[index].horizontal_alignment = header_resource.content_horizontal_alignment
		# 	cells[index].vertical_alignment = header_resource.content_vertical_alignment
		# 	cells[index].width_ratio = header_resource.width_ratio
		# 	cells[index].overflow_mode = header_resource.overflow_mode
			
		# index += 1

	# (func():
	# 	for row: TableRow in %RowsVBoxContainer.get_children():
	# 		row.update_vertical_separators(%TableHeader.get_separators(), self.rows_vertical_separators_visible)
	# ).call_deferred()

	if Engine.is_editor_hint():
		self._update_preview_rows()
	else:
		self._update_rows()


func set_header_height(height: float) -> void:
	header_height = height
	%TableHeader.custom_minimum_size.y = header_height


func set_headers_vertical_separator_visible(visible: bool) -> void:
	headers_vertical_separator_visible = visible
	%TableHeader.set_separators_visible(headers_vertical_separator_visible)


func set_headers_horizontal_separator_visible(visible: bool) -> void:
	headers_horizontal_separator_visible = visible
	%HeaderRowsSeparator.visible = headers_horizontal_separator_visible


func set_headers_horizontal_separators_offset(offset: float) -> void:
	headers_horizontal_separators_offset = offset
	%HeaderRowsSeparator.position.y = headers_horizontal_separators_offset


func set_row_height(height: float) -> void:
	for row: TableRow in %RowsVBoxContainer.get_children():
		row.custom_minimum_size.y = height


func set_rows_vertical_separators_visible(visible: bool) -> void:
	rows_vertical_separators_visible = visible
	(func():
		var separators: Array[Control] = %TableHeader.get_separators()
		for row: TableRow in %RowsVBoxContainer.get_children():
			row.update_vertical_separators(separators, rows_vertical_separators_visible)
	).call_deferred()


func set_rows_horizontal_separators_visible(visible: bool) -> void:
	rows_horizontal_separators_visible = visible
	self._update_rows_horizontal_separators()


func set_rows_horizontal_separators_offset(offset: float) -> void:
	rows_horizontal_separators_offset = offset
	self._update_rows_horizontal_separators()


func set_preview_data(data: Array[Array]) -> void:
	if not Engine.is_editor_hint():
		return
	preview_data = data
	self._update_preview_rows()


func set_number_cell_decimal_places(decimal_places: int) -> void:
	number_cell_decimal_places = decimal_places
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is NumberTableCell:
				cell.decimals = decimal_places


func set_number_cell_delimiter_type(delimiter_type: NumberTableCell.DelimiterType) -> void:
	number_cell_delimiter_type = delimiter_type
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is NumberTableCell:
				cell.delimiter_type = delimiter_type


func set_number_cell_round_mode(round_mode: NumberTableCell.RoundMode) -> void:
	number_cell_round_mode = round_mode
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is NumberTableCell:
				cell.round_mode = round_mode


func set_currency_cell_decimal_places(decimal_places: int) -> void:
	currency_cell_decimal_places = decimal_places
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is CurrencyTableCell:
				cell.decimal_places = decimal_places


func set_currency_cell_round_mode(round_mode: CurrencyTableCell.RoundMode) -> void:
	currency_cell_round_mode = round_mode
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is CurrencyTableCell:
				cell.round_mode = round_mode


func set_currency_cell_currency_symbol(symbol: String) -> void:
	currency_cell_currency_symbol = symbol
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is CurrencyTableCell:
				cell.currency_symbol = symbol


func set_percentage_cell_decimal_places(decimal_places: int) -> void:
	percentage_cell_decimal_places = decimal_places
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is PercentageTableCell:
				cell.decimals = decimal_places

func set_percentage_cell_round_mode(round_mode: PercentageTableCell.RoundMode) -> void:
	percentage_cell_round_mode = round_mode
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is PercentageTableCell:
				cell.round_mode = round_mode


func set_date_cell_display_format(display_format: DateTableCell.DateFormat) -> void:
	date_cell_display_format = display_format
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is DateTableCell:
				cell.display_format = display_format


func set_progress_cell_fill_mode(fill_mode: ProgressBar.FillMode) -> void:
	progress_cell_fill_mode = fill_mode
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is ProgressTableCell:
				cell.fill_mode = fill_mode


func set_progress_cell_show_percentage(show: bool) -> void:
	progress_cell_show_percentage = show
	for row: TableRow in %RowsVBoxContainer.get_children():
		for cell: TableCell in row.get_cells():
			if cell is ProgressTableCell:
				cell.show_percentage = show


func set_scroll_bar_visible(visible: ScrollbarVisibility) -> void:
	scroll_bar_visible = visible
	self._update_scroll_bar()


func set_scroll_bar_custom_step(step: float) -> void:
	scroll_bar_custom_step = step
	%OuterVScrollBar.custom_step = step


func set_title_header_separation(separation: float) -> void:
	title_header_separation = separation
	%RootVBoxContainer.add_theme_constant_override("separation", title_header_separation)


func set_header_rows_separation(separation: float) -> void:
	header_rows_separation = separation
	%ContentVBoxContainer.add_theme_constant_override("separation", header_rows_separation)


func set_content_scroll_bar_separation(separation: float) -> void:
	content_scroll_bar_separation = separation
	%BodyHBoxContainer.add_theme_constant_override("separation", content_scroll_bar_separation)


func set_line_spacing(separation: float) -> void:
	line_spacing = separation
	%RowsVBoxContainer.add_theme_constant_override("separation", line_spacing)


func set_interaction_mode(mode: InteractionMode) -> void:
	interaction_mode = mode


func update_theme(theme: TablePlusTheme) -> void:
	self._current_theme = theme
	if theme.title_font != null:
		%TitleLabel.add_theme_font_override("normal_font", theme.title_font)
	else:
		%TitleLabel.add_theme_font_override("normal_font", self.get_theme_default_font())
	%TitleLabel.add_theme_font_size_override("normal_font_size", theme.title_font_size)
	%TitleLabel.add_theme_color_override("default_color", theme.title_font_color)
	%HeaderRowsSeparator.add_theme_stylebox_override("panel", theme.header_horizontal_separator_stylebox)
	for row: TableRow in %RowsVBoxContainer.get_children():
		var stylebox_index: int = 0
		if theme.row_enable_zebra_stripes:
			stylebox_index = row.get_index() % theme.row_background_styleboxs.size()
		row.add_theme_stylebox_override("panel", theme.row_background_styleboxs[stylebox_index])
	if theme.scroll_bar_icons_increment != null:
		%OuterVScrollBar.add_theme_icon_override("increment", theme.scroll_bar_icons_increment)
	if theme.scroll_bar_icons_increment_highlight != null:
		%OuterVScrollBar.add_theme_icon_override("increment_highlight", theme.scroll_bar_icons_increment_highlight)
	if theme.scroll_bar_icons_increment_pressed != null:
		%OuterVScrollBar.add_theme_icon_override("increment_pressed", theme.scroll_bar_icons_increment_pressed)
	if theme.scroll_bar_icons_decrement != null:
		%OuterVScrollBar.add_theme_icon_override("decrement", theme.scroll_bar_icons_decrement)
	if theme.scroll_bar_icons_decrement_highlight != null:
		%OuterVScrollBar.add_theme_icon_override("decrement_highlight", theme.scroll_bar_icons_decrement_highlight)
	if theme.scroll_bar_icons_decrement_pressed != null:
		%OuterVScrollBar.add_theme_icon_override("decrement_pressed", theme.scroll_bar_icons_decrement_pressed)
	if theme.scroll_bar_styles_scroll != null:
		%OuterVScrollBar.add_theme_stylebox_override("scroll", theme.scroll_bar_styles_scroll)
	if theme.scroll_bar_styles_scroll_focus != null:
		%OuterVScrollBar.add_theme_stylebox_override("scroll_focus", theme.scroll_bar_styles_scroll_focus)
	if theme.scroll_bar_styles_grabber != null:
		%OuterVScrollBar.add_theme_stylebox_override("grabber", theme.scroll_bar_styles_grabber)
	if theme.scroll_bar_styles_grabber_highlight != null:
		%OuterVScrollBar.add_theme_stylebox_override("grabber_highlight", theme.scroll_bar_styles_grabber_highlight)
	if theme.scroll_bar_styles_grabber_pressed != null:
		%OuterVScrollBar.add_theme_stylebox_override("grabber_pressed", theme.scroll_bar_styles_grabber_pressed)
	%OuterVScrollBar.add_theme_constant_override("padding_left", theme.scroll_bar_constants_padding_left)
	%OuterVScrollBar.add_theme_constant_override("padding_right", theme.scroll_bar_constants_padding_right)


func _update_rows() -> void:
	self._populate_rows(self.data)


func _update_preview_rows() -> void:
	self._populate_rows(self.preview_data)


func _populate_rows(source_data: Array[Array]) -> void:
	for row: Control in %RowsVBoxContainer.get_children():
		%RowsVBoxContainer.remove_child(row)
		row.queue_free()
	(func():
		var row_index: int = 0
		for row_data: Array in source_data:
			var row: TableRow = TABLE_ROW.instantiate()
			row.custom_minimum_size.y = self.row_height
			row.update_vertical_separators(%TableHeader.get_separators(), self.rows_vertical_separators_visible)
			var horizontal_separator_visible: bool = self.rows_horizontal_separators_visible
			if row_index == source_data.size() - 1:
				horizontal_separator_visible = false
			row.update_horizontal_separators(horizontal_separator_visible, self.rows_horizontal_separators_offset)
			row.resized.connect(func():
				row.update_vertical_separators(%TableHeader.get_separators(), self.rows_vertical_separators_visible)
			)
			row.update_theme(self._current_theme)
			row.set_background_stylebox(row_index)
			var row_data_configs: Array[TableCell.CellConfig] = []
			var cell_index: int = 0
			var header_cells: Array[TableHeaderCell] = %TableHeader.get_cells()
			for cell_data in row_data:
				var cell_config: TableCell.CellConfig = TableCell.CellConfig.new()
				cell_config.type = header_cells[cell_index].type
				cell_config.content = cell_data
				cell_config.horizontal_alignment = header_cells[cell_index].content_horizontal_alignment
				cell_config.vertical_alignment = header_cells[cell_index].content_vertical_alignment
				cell_config.width_ratio = header_cells[cell_index].width_ratio
				cell_config.overflow_mode = header_cells[cell_index].overflow_mode
				row_data_configs.append(cell_config)
				cell_index += 1
			row.set_data(row_data_configs, self)
			row.clicked.connect(func(): self.row_clicked.emit(row_index, row))
			row.mouse_entered.connect(func(): self.row_mouse_entered.emit(row_index, row))
			row.mouse_exited.connect(func(): self.row_mouse_exited.emit(row_index, row))
			row.cell_clicked.connect(func(column_index: int, cell: TableCell):
				self.cell_clicked.emit(row_index, column_index, cell))
			%RowsVBoxContainer.add_child(row)
			row_index += 1
	).call_deferred()


func _on_header_cell_sorted(cell_id: String, sort_state: TableGlobals.SortState) -> void:
	var header_cells: Array[TableHeaderCell] = %TableHeader.get_cells()
	var cell_index: int = header_cells.find_custom(func(cell: TableHeaderCell) -> bool:
		return cell.id == cell_id
	)
	if cell_index == -1:
		return
	var header_cell: TableHeaderCell = header_cells[cell_index]
	var temp_table_cell: TableCell = TableCellFactory.create_table_cell(header_cell.type)
	# 对数据进行排序，然后重新创建行
	var sorted_data: Array[Array] = self.data.duplicate()
	sorted_data.sort_custom(func(a: Array, b: Array) -> int:
		var a_value: Variant = a[cell_index]
		var b_value: Variant = b[cell_index]
		return temp_table_cell.compare_values(a_value, b_value, sort_state)
	)
	self._populate_rows(sorted_data)


func _update_rows_horizontal_separators() -> void:
	(func():
		if %RowsVBoxContainer.get_child_count() <= 0:
			return
		var last_row: TableRow = %RowsVBoxContainer.get_children().back()
		if last_row == null:
			return
		for row: TableRow in %RowsVBoxContainer.get_children():
			if row == last_row:
				row.update_horizontal_separators(false, self.rows_horizontal_separators_offset)
				continue
			row.update_horizontal_separators(self.rows_horizontal_separators_visible, self.rows_horizontal_separators_offset)
	).call_deferred()


func _update_scroll_bar() -> void:
	match self.scroll_bar_visible:
		ScrollbarVisibility.Auto:
			if %RowsVBoxContainer.size.y > %RowsScrollContainer.size.y:
				%OuterVScrollBar.visible = true
			else:
				%OuterVScrollBar.visible = false
		ScrollbarVisibility.AlwaysShow:
			%OuterVScrollBar.visible = true
		ScrollbarVisibility.NeverShow:
			%OuterVScrollBar.visible = false
	%OuterVScrollBar.min_value = 0.0
	%OuterVScrollBar.max_value = %RowsVBoxContainer.size.y
	%OuterVScrollBar.page = %RowsScrollContainer.size.y / %RowsVBoxContainer.size.y * %OuterVScrollBar.max_value


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			%OuterVScrollBar.value = max(%OuterVScrollBar.min_value, %OuterVScrollBar.value - self.scroll_bar_custom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			%OuterVScrollBar.value = min(%OuterVScrollBar.max_value, %OuterVScrollBar.value + self.scroll_bar_custom_step)


func _on_resized() -> void:
	self._update_scroll_bar()


func _on_scroll_bar_value_changed(value: float) -> void:
	%RowsScrollContainer.scroll_vertical = value
