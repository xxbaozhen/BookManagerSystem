@tool
extends Control


signal export_data_changed(key: String, value: Variant)
signal row_clicked(row_index: int, row: TableRow)
signal row_mouse_entered(row_index: int, row: TableRow)
signal row_mouse_exited(row_index: int, row: TableRow)
signal cell_clicked(row_index: int, column_index: int, cell: TableCell)


const TABLE_ROOT: PackedScene = preload("uid://dnhalt8e54to5")


## 标题设置
@export_group("Title Settings")

## 标题可见性
@export var title_visible: bool = true:
	set(value):
		title_visible = value
		self.export_data_changed.emit("title_visible", title_visible)

## 标题文本
@export var title_text: String = "Title":
	set(value):
		title_text = value
		self.export_data_changed.emit("title_text", title_text)

## 标题对齐方式
@export var title_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT:
	set(value):
		title_alignment = value
		self.export_data_changed.emit("title_alignment", title_alignment)

## 表头设置
@export_group("Header Settings")

## 表头内容
@export var headers: Array[TableHeaderCellResource]:
	set(value):
		headers = value
		for cell_resource: TableHeaderCellResource in headers:
			if cell_resource == null:
				continue
			if cell_resource != null:
				if cell_resource.changed.is_connected(self._on_header_cell_resource_changed):
					cell_resource.changed.disconnect(self._on_header_cell_resource_changed)
			cell_resource.changed.connect(self._on_header_cell_resource_changed)
		self.export_data_changed.emit("headers", headers)

## 表头高度
@export var headers_height: float = 50.0:
	set(value):
		headers_height = value
		self.export_data_changed.emit("header_height", headers_height)

## 表头垂直分割线可见性
@export var headers_vertical_separator_visible: bool = true:
	set(value):
		headers_vertical_separator_visible = value
		self.export_data_changed.emit("headers_vertical_separator_visible", headers_vertical_separator_visible)

## 表头水平分割线可见性
@export var headers_horizontal_separator_visible: bool = true:
	set(value):
		headers_horizontal_separator_visible = value
		self.export_data_changed.emit("headers_horizontal_separator_visible", headers_horizontal_separator_visible)

## 表头水平分割线偏移
@export var headers_horizontal_separators_offset: float = 0.0:
	set(value):
		headers_horizontal_separators_offset = value
		self.export_data_changed.emit("headers_horizontal_separators_offset", headers_horizontal_separators_offset)

## 行设置
@export_group("Row Settings")

## 行高
@export var row_height: float = 50.0:
	set(value):
		row_height = value
		self.export_data_changed.emit("row_height", row_height)

## 行垂直分割线可见性
@export var rows_vertical_separators_visible: bool = true:
	set(value):
		rows_vertical_separators_visible = value
		self.export_data_changed.emit("rows_vertical_separators_visible", rows_vertical_separators_visible)

## 行水平分割线可见性
@export var rows_horizontal_separators_visible: bool = true:
	set(value):
		rows_horizontal_separators_visible = value
		self.export_data_changed.emit("rows_horizontal_separators_visible", rows_horizontal_separators_visible)

## 行水平分割线偏移
@export var rows_horizontal_separators_offset: float = 0.0:
	set(value):
		rows_horizontal_separators_offset = value
		self.export_data_changed.emit("rows_horizontal_separators_offset", rows_horizontal_separators_offset)

## 预览设置
@export_subgroup("Preview Settings")

## 预览内容
@export var preview_data: Array[Array] = []:
	set(value):
		preview_data = value
		self.export_data_changed.emit("preview_data", preview_data)

## 单元格设置
@export_group("Cell Settings")

## 文本单元格设置
@export_subgroup("Text Cell Settings")

## 数字单元格设置
@export_subgroup("Number Cell Settings")

## 小数位数
@export var number_cell_decimal_places: int = 0:
	set(value):
		number_cell_decimal_places = value
		self.export_data_changed.emit("number_cell_decimal_places", number_cell_decimal_places)

## 分位类型
@export var number_cell_delimiter_type: NumberTableCell.DelimiterType = NumberTableCell.DelimiterType.NONE:
	set(value):
		number_cell_delimiter_type = value
		self.export_data_changed.emit("number_cell_delimiter_type", number_cell_delimiter_type)

## 舍入模式
@export var number_cell_round_mode: NumberTableCell.RoundMode = NumberTableCell.RoundMode.ROUND:
	set(value):
		number_cell_round_mode = value
		self.export_data_changed.emit("number_cell_round_mode", number_cell_round_mode)

## 货币单元格设置
@export_subgroup("Currency Cell Settings")

## 小数位数
@export var currency_cell_decimal_places: int = 1:
	set(value):
		currency_cell_decimal_places = value
		self.export_data_changed.emit("currency_cell_decimal_places", currency_cell_decimal_places)

## 舍入模式
@export var currency_cell_round_mode: CurrencyTableCell.RoundMode = CurrencyTableCell.RoundMode.ROUND:
	set(value):
		currency_cell_round_mode = value
		self.export_data_changed.emit("currency_cell_round_mode", currency_cell_round_mode)

## 货币符号
@export var currency_cell_currency_symbol: String = "$":
	set(value):
		currency_cell_currency_symbol = value
		self.export_data_changed.emit("currency_cell_currency_symbol", currency_cell_currency_symbol)

## 百分比单元格设置
@export_subgroup("Percentage Cell Settings")

## 小数位数
@export var percentage_cell_decimal_places: int = 0:
	set(value):
		percentage_cell_decimal_places = value
		self.export_data_changed.emit("percentage_cell_decimal_places", percentage_cell_decimal_places)

## 舍入模式
@export var percentage_cell_round_mode: PercentageTableCell.RoundMode = PercentageTableCell.RoundMode.ROUND:
	set(value):
		percentage_cell_round_mode = value
		self.export_data_changed.emit("percentage_cell_round_mode", percentage_cell_round_mode)

## 日期单元格设置
@export_subgroup("Date Cell Settings")

## 显示格式
@export var date_cell_display_format: DateTableCell.DateFormat = DateTableCell.DateFormat.YYYY_MM_DD:
	set(value):
		date_cell_display_format = value
		self.export_data_changed.emit("date_cell_display_format", date_cell_display_format)

## 布尔单元格设置
@export_subgroup("Boolean Cell Settings")

## 进度条单元格设置
@export_subgroup("Progress Cell Settings")

## 填充方向
@export var progress_cell_fill_mode: ProgressBar.FillMode = ProgressBar.FillMode.FILL_BEGIN_TO_END:
	set(value):
		progress_cell_fill_mode = value
		self.export_data_changed.emit("progress_cell_fill_mode", progress_cell_fill_mode)

## 百分比显示
@export var progress_cell_show_percentage: bool = true:
	set(value):
		progress_cell_show_percentage = value
		self.export_data_changed.emit("progress_cell_show_percentage", progress_cell_show_percentage)

## 滚动条设置
@export_group("Scroll Bar Settings")

## 滚动条可见性
@export var scroll_bar_visible: TableRoot.ScrollbarVisibility = TableRoot.ScrollbarVisibility.Auto:
	set(value):
		scroll_bar_visible = value
		self.export_data_changed.emit("scroll_bar_visible", scroll_bar_visible)

## 自定义步长
@export var scroll_bar_custom_step: float = 10.0:
	set(value):
		scroll_bar_custom_step = value
		self.export_data_changed.emit("scroll_bar_custom_step", scroll_bar_custom_step)

## 间距设置
@export_group("Separation")

## 标题与表头间距
@export var title_header_separation: float = 0.0:
	set(value):
		title_header_separation = value
		self.export_data_changed.emit("title_header_separation", title_header_separation)

## 表头行间距
@export var header_rows_separation: float = 0.0:
	set(value):
		header_rows_separation = value
		self.export_data_changed.emit("header_rows_separation", header_rows_separation)

## 内容与滚动条间距
@export var content_scroll_bar_separation: float = 0.0:
	set(value):
		content_scroll_bar_separation = value
		self.export_data_changed.emit("content_scroll_bar_separation", content_scroll_bar_separation)

## 行间距
@export var line_spacing: float = 0.0:
	set(value):
		line_spacing = value
		self.export_data_changed.emit("line_spacing", line_spacing)

@export_group("Interaction Settings")

## 交互模式
@export var interaction_mode: TableRoot.InteractionMode = TableRoot.InteractionMode.Row:
	set(value):
		interaction_mode = value
		self.export_data_changed.emit("interaction_mode", interaction_mode)

@export_group("Theme Settings")

@export var custom_theme: TablePlusTheme = null:
	set(value):
		if custom_theme != null:
			if custom_theme.changed.is_connected(self._on_custom_theme_changed):
				custom_theme.changed.disconnect(self._on_custom_theme_changed)
		if value == null:
			value = TablePlusTheme.new()
		custom_theme = value
		custom_theme.changed.connect(self._on_custom_theme_changed)
		self._on_custom_theme_changed()


var data: Array[Array] = []: set = set_data

var table_root: TableRoot = null

func _ready() -> void:
	self._init_table_root()
	self._init_and_update_custom_theme()
	self.export_data_changed.connect(self._on_export_data_changed)


func set_data(new_data: Array[Array]) -> void:
	data = new_data
	if self.table_root == null:
		return
	self.table_root.set_data(data)


func _init_table_root() -> void:
	self.table_root = TABLE_ROOT.instantiate()
	self.add_child(self.table_root)

	self.resized.connect(func(): self.table_root.set_resize(self.size))
	self.table_root.row_clicked.connect(func(row_index: int, row: TableRow): self.row_clicked.emit(row_index, row))
	self.table_root.row_mouse_entered.connect(func(row_index: int, row: TableRow): self.row_mouse_entered.emit(row_index, row))
	self.table_root.row_mouse_exited.connect(func(row_index: int, row: TableRow): self.row_mouse_exited.emit(row_index, row))
	self.table_root.cell_clicked.connect(func(row_index: int, column_index: int, cell: TableCell):
		self.cell_clicked.emit(row_index, column_index, cell))

	self.table_root.set_title_text(self.title_text)
	self.table_root.set_title_alignment(self.title_alignment)
	self.table_root.set_headers(self.headers)
	self.table_root.set_header_height(self.headers_height)
	self.table_root.set_headers_vertical_separator_visible(self.headers_vertical_separator_visible)
	self.table_root.set_headers_horizontal_separator_visible(self.headers_horizontal_separator_visible)
	self.table_root.set_headers_horizontal_separators_offset(self.headers_horizontal_separators_offset)
	self.table_root.set_row_height(self.row_height)
	self.table_root.set_rows_vertical_separators_visible(self.rows_vertical_separators_visible)
	self.table_root.set_rows_horizontal_separators_visible(self.rows_horizontal_separators_visible)
	self.table_root.set_rows_horizontal_separators_offset(self.rows_horizontal_separators_offset)
	self.table_root.set_preview_data(self.preview_data)
	self.table_root.set_number_cell_decimal_places(self.number_cell_decimal_places)
	self.table_root.set_number_cell_delimiter_type(self.number_cell_delimiter_type)
	self.table_root.set_number_cell_round_mode(self.number_cell_round_mode)
	self.table_root.set_currency_cell_decimal_places(self.currency_cell_decimal_places)
	self.table_root.set_currency_cell_round_mode(self.currency_cell_round_mode)
	self.table_root.set_currency_cell_currency_symbol(self.currency_cell_currency_symbol)
	self.table_root.set_percentage_cell_decimal_places(self.percentage_cell_decimal_places)
	self.table_root.set_percentage_cell_round_mode(self.percentage_cell_round_mode)
	self.table_root.set_date_cell_display_format(self.date_cell_display_format)
	self.table_root.set_progress_cell_fill_mode(self.progress_cell_fill_mode)
	self.table_root.set_progress_cell_show_percentage(self.progress_cell_show_percentage)
	self.table_root.set_scroll_bar_visible(self.scroll_bar_visible)
	self.table_root.set_title_header_separation(self.title_header_separation)
	self.table_root.set_header_rows_separation(self.header_rows_separation)
	self.table_root.set_content_scroll_bar_separation(self.content_scroll_bar_separation)
	self.table_root.set_line_spacing(self.line_spacing)
	self.table_root.set_interaction_mode(self.interaction_mode)


func _init_and_update_custom_theme() -> void:
	# 广度优先搜索（BFS）：遍历所有子节点，调用存在的 update_theme 方法
	var MAX_DEPTH: int = 32
	var queue: Array[Dictionary] = []
	# 从当前节点的直接子节点开始入队
	for child: Node in self.get_children():
		queue.append({"node": child, "depth": 0})
	while queue.size() > 0:
		var item: Dictionary = queue.pop_front()
		var node: Node = item["node"]
		var depth: int = item["depth"]
		if node == null:
			continue
		if node.has_method("update_theme"):
			node.update_theme(self.custom_theme)
		# 深度限制，避免意外的无限遍历
		if depth < MAX_DEPTH:
			for child: Node in node.get_children():
				queue.append({"node": child, "depth": depth + 1})


func _on_export_data_changed(key: String, value: Variant) -> void:
	if self.table_root == null:
		return
	match key:
		"title_visible":
			self.table_root.set_title_visible(value)
		"title_text":
			self.table_root.set_title_text(value)
		"title_alignment":
			self.table_root.set_title_alignment(value)
		"headers":
			self.table_root.set_headers(value)
		"header_height":
			self.table_root.set_header_height(value)
		"headers_vertical_separator_visible":
			self.table_root.set_headers_vertical_separator_visible(value)
		"headers_horizontal_separator_visible":
			self.table_root.set_headers_horizontal_separator_visible(value)
		"headers_horizontal_separators_offset":
			self.table_root.set_headers_horizontal_separators_offset(value)
		"row_height":
			self.table_root.set_row_height(value)
		"rows_vertical_separators_visible":
			self.table_root.set_rows_vertical_separators_visible(value)
		"rows_horizontal_separators_visible":
			self.table_root.set_rows_horizontal_separators_visible(value)
		"rows_horizontal_separators_offset":
			self.table_root.set_rows_horizontal_separators_offset(value)
		"preview_data":
			self.table_root.set_preview_data(value)
		"number_cell_decimal_places":
			self.table_root.set_number_cell_decimal_places(value)
		"number_cell_delimiter_type":
			self.table_root.set_number_cell_delimiter_type(value)
		"number_cell_round_mode":
			self.table_root.set_number_cell_round_mode(value)
		"currency_cell_decimal_places":
			self.table_root.set_currency_cell_decimal_places(value)
		"currency_cell_round_mode":
			self.table_root.set_currency_cell_round_mode(value)
		"currency_cell_currency_symbol":
			self.table_root.set_currency_cell_currency_symbol(value)
		"percentage_cell_decimal_places":
			self.table_root.set_percentage_cell_decimal_places(value)
		"percentage_cell_round_mode":
			self.table_root.set_percentage_cell_round_mode(value)
		"date_cell_display_format":
			self.table_root.set_date_cell_display_format(value)
		"progress_cell_fill_mode":
			self.table_root.set_progress_cell_fill_mode(value)
		"progress_cell_show_percentage":
			self.table_root.set_progress_cell_show_percentage(value)
		"scroll_bar_visible":
			self.table_root.set_scroll_bar_visible(value)
		"scroll_bar_custom_step":
			self.table_root.set_scroll_bar_custom_step(value)
		"title_header_separation":
			self.table_root.set_title_header_separation(value)
		"header_rows_separation":
			self.table_root.set_header_rows_separation(value)
		"content_scroll_bar_separation":
			self.table_root.set_content_scroll_bar_separation(value)
		"line_spacing":
			self.table_root.set_line_spacing(value)
		"interaction_mode":
			self.table_root.set_interaction_mode(value)


func _on_custom_theme_changed() -> void:
	self._init_and_update_custom_theme()


func _on_header_cell_resource_changed() -> void:
	self.export_data_changed.emit("headers", self.headers)
