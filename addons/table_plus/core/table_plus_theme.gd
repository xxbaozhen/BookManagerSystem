@tool
class_name TablePlusTheme
extends Resource


@export_group("Title", "title_")

## 标题字体
@export var title_font: Font:
	set(value):
		title_font = value
		self.emit_changed()

## 标题字体大小
@export var title_font_size: int = 36:
	set(value):
		title_font_size = value
		self.emit_changed()

## 标题字体颜色
@export var title_font_color: Color = Color(1.0, 1.0, 1.0, 1.0):
	set(value):
		title_font_color = value
		self.emit_changed()

@export_group("Header", "header_")

## 表头背景样式
@export var header_background_stylebox: StyleBox = self._get_default_header_background_stylebox():
	set(value):
		if value == null:
			value = self._get_default_header_background_stylebox()
		header_background_stylebox = value
		self.emit_changed()

## 表头垂直分割线样式
@export var header_vertical_separator_stylebox: StyleBox = self._get_default_header_vertical_separator_stylebox():
	set(value):
		if value == null:
			value = self._get_default_header_vertical_separator_stylebox()
		header_vertical_separator_stylebox = value
		self.emit_changed()

## 表头水平分割线样式
@export var header_horizontal_separator_stylebox: StyleBox = self._get_default_header_horizontal_separator_stylebox():
	set(value):
		if value == null:
			value = self._get_default_header_horizontal_separator_stylebox()
		header_horizontal_separator_stylebox = value
		self.emit_changed()

@export_subgroup("Header Cell", "header_cell_")

## 表头单元格字体
@export var header_cell_font: Font:
	set(value):
		header_cell_font = value
		self.emit_changed()

## 表头单元格字体大小
@export var header_cell_font_size: int = 16:
	set(value):
		header_cell_font_size = value
		self.emit_changed()

## 表头单元格字体颜色
@export var header_cell_font_color: Color = Color(1.0, 1.0, 1.0, 1.0):
	set(value):
		header_cell_font_color = value
		self.emit_changed()

## 表头单元格背景样式
@export var header_cell_background_stylebox: StyleBox = self._get_default_header_cell_background_stylebox():
	set(value):
		if value == null:
			value = self._get_default_header_cell_background_stylebox()
		header_cell_background_stylebox = value
		self.emit_changed()

## 升序按钮图标
@export var header_cell_asc_button_texture: Texture2D = null:
	set(value):
		header_cell_asc_button_texture = value
		self.emit_changed()

## 降序按钮图标
@export var header_cell_desc_button_texture: Texture2D = null:
	set(value):
		header_cell_desc_button_texture = value
		self.emit_changed()

@export_group("Row", "row_")

## 启用斑马纹背景
@export var row_enable_zebra_stripes: bool = true:
	set(value):
		row_enable_zebra_stripes = value
		self.emit_changed()

## 行背景样式
@export var row_background_styleboxs: Array[StyleBox] = self._get_default_row_background_styleboxs():
	set(value):
		if value == null or value.size() == 0:
			value = self._get_default_row_background_styleboxs()
		row_background_styleboxs = value
		self.emit_changed()

## 行悬停背景样式
@export var row_hover_background_stylebox: Array[StyleBox] = self._get_default_row_hover_background_styleboxs():
	set(value):
		if value == null or value.size() == 0:
			value = self._get_default_row_hover_background_styleboxs()
		row_hover_background_stylebox = value
		self.emit_changed()

## 行垂直分割线样式
@export var row_vertical_separator_stylebox: StyleBox = self._get_default_row_vertical_separator_stylebox():
	set(value):
		if value == null:
			value = self._get_default_row_vertical_separator_stylebox()
		row_vertical_separator_stylebox = value
		self.emit_changed()

## 行水平分割线样式
@export var row_horizontal_separator_stylebox: StyleBox = self._get_default_row_horizontal_separator_stylebox():
	set(value):
		if value == null:
			value = self._get_default_row_horizontal_separator_stylebox()
		row_horizontal_separator_stylebox = value
		self.emit_changed()

@export_subgroup("Row Cell", "row_cell_")

## 行单元格字体
@export var row_cell_font: Font:
	set(value):
		row_cell_font = value
		self.emit_changed()

## 行单元格字体大小
@export var row_cell_font_size: int = 16:
	set(value):
		row_cell_font_size = value
		self.emit_changed()

## 行单元格字体颜色
@export var row_cell_font_color: Color = Color(1.0, 1.0, 1.0, 1.0):
	set(value):
		row_cell_font_color = value
		self.emit_changed()

## 行单元格背景样式
@export var row_cell_background_stylebox: StyleBox = self._get_default_row_cell_background_stylebox():
	set(value):
		if value == null:
			value = self._get_default_row_cell_background_stylebox()
		row_cell_background_stylebox = value
		self.emit_changed()

## 行单元格悬停背景样式
@export var row_cell_hover_background_stylebox: StyleBox = self._get_default_row_cell_hover_background_stylebox():
	set(value):
		if value == null:
			value = self._get_default_row_cell_hover_background_stylebox()
		row_cell_hover_background_stylebox = value
		self.emit_changed()

@export_group("Scrollbar")

@export_group("Cell")

@export_subgroup("Text Cell", "text_cell_")

## 文本单元格背景样式
@export var text_cell_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		text_cell_background_stylebox = value
		self.emit_changed()

## 文本单元格悬停背景样式
@export var text_cell_hover_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		text_cell_hover_background_stylebox = value
		self.emit_changed()

@export_subgroup("Number Cell", "number_cell_")

## 数字单元格背景样式
@export var number_cell_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		number_cell_background_stylebox = value
		self.emit_changed()

## 数字单元格悬停背景样式
@export var number_cell_hover_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		number_cell_hover_background_stylebox = value
		self.emit_changed()


@export_subgroup("Currency Cell", "currency_cell_")

## 货币单元格背景样式
@export var currency_cell_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		currency_cell_background_stylebox = value
		self.emit_changed()

## 货币单元格悬停背景样式
@export var currency_cell_hover_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		currency_cell_hover_background_stylebox = value
		self.emit_changed()

@export_subgroup("Percentage Cell", "percentage_cell_")

## 百分比单元格背景样式
@export var percentage_cell_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		percentage_cell_background_stylebox = value
		self.emit_changed()

## 百分比单元格悬停背景样式
@export var percentage_cell_hover_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		percentage_cell_hover_background_stylebox = value
		self.emit_changed()

@export_subgroup("Date Cell", "date_cell_")

## 日期单元格背景样式
@export var date_cell_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		date_cell_background_stylebox = value
		self.emit_changed()

## 日期单元格悬停背景样式
@export var date_cell_hover_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		date_cell_hover_background_stylebox = value
		self.emit_changed()

@export_subgroup("Boolean Cell", "boolean_cell_")

## 布尔单元格背景样式
@export var boolean_cell_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		boolean_cell_background_stylebox = value
		self.emit_changed()

## 布尔单元格悬停背景样式
@export var boolean_cell_hover_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		boolean_cell_hover_background_stylebox = value
		self.emit_changed()

## 布尔单元格“真”图标
@export var boolean_cell_true_icon: Texture = self._get_default_boolean_cell_true_icon():
	set(value):
		if value == null:
			value = self._get_default_boolean_cell_true_icon()
		boolean_cell_true_icon = value
		self.emit_changed()

## 布尔单元格“假”图标
@export var boolean_cell_false_icon: Texture = self._get_default_boolean_cell_false_icon():
	set(value):
		if value == null:
			value = self._get_default_boolean_cell_false_icon()
		boolean_cell_false_icon = value
		self.emit_changed()

@export_subgroup("Progress Cell", "progress_cell_")

## 进度单元格背景样式
@export var progress_cell_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		progress_cell_background_stylebox = value
		self.emit_changed()

## 进度单元格悬停背景样式
@export var progress_cell_hover_background_stylebox: StyleBox = StyleBoxEmpty.new():
	set(value):
		if value == null:
			value = StyleBoxEmpty.new()
		progress_cell_hover_background_stylebox = value
		self.emit_changed()

@export_subgroup("Progress Cell/Progress Bar", "progress_cell_progress_bar_")

@export var progress_cell_progress_bar_font_color: Color = Color(1.0, 1.0, 1.0, 1.0):
	set(value):
		progress_cell_progress_bar_font_color = value
		self.emit_changed()

@export var progress_cell_progress_bar_font_outline_color: Color = Color(0.0, 0.0, 0.0, 1.0):
	set(value):
		progress_cell_progress_bar_font_outline_color = value
		self.emit_changed()

@export var progress_cell_progress_bar_outline_size: int = 0.0:
	set(value):
		progress_cell_progress_bar_outline_size = value
		self.emit_changed()

@export var progress_cell_progress_bar_font: Font = null:
	set(value):
		progress_cell_progress_bar_font = value
		self.emit_changed()

@export var progress_cell_progress_bar_font_size: int = 16:
	set(value):
		progress_cell_progress_bar_font_size = value
		self.emit_changed()

@export var progress_cell_progress_bar_background: StyleBox = self._get_default_progress_cell_progress_bar_background_stylebox():
	set(value):
		if value == null:
			value = self._get_default_progress_cell_progress_bar_background_stylebox()
		progress_cell_progress_bar_background = value
		self.emit_changed()

@export var progress_cell_progress_bar_fill: StyleBox = self._get_default_progress_cell_progress_bar_fill_stylebox():
	set(value):
		if value == null:
			value = self._get_default_progress_cell_progress_bar_fill_stylebox()
		progress_cell_progress_bar_fill = value
		self.emit_changed()

@export_group("Scroll Bar")

@export_subgroup("Icons", "scroll_bar_icons_")

@export var scroll_bar_icons_increment: ImageTexture = null:
	set(value):
		scroll_bar_icons_increment = value
		self.emit_changed()

@export var scroll_bar_icons_increment_highlight: ImageTexture = null:
	set(value):
		scroll_bar_icons_increment_highlight = value
		self.emit_changed()

@export var scroll_bar_icons_increment_pressed: ImageTexture = null:
	set(value):
		scroll_bar_icons_increment_pressed = value
		self.emit_changed()

@export var scroll_bar_icons_decrement: ImageTexture = null:
	set(value):
		scroll_bar_icons_decrement = value
		self.emit_changed()

@export var scroll_bar_icons_decrement_highlight: ImageTexture = null:
	set(value):
		scroll_bar_icons_decrement_highlight = value
		self.emit_changed()

@export var scroll_bar_icons_decrement_pressed: ImageTexture = null:
	set(value):
		scroll_bar_icons_decrement_pressed = value
		self.emit_changed()

@export_subgroup("Styles", "scroll_bar_styles_")

@export var scroll_bar_styles_scroll: StyleBox = self._get_default_scroll_bar_styles_scroll():
	set(value):
		if value == null:
			value = self._get_default_scroll_bar_styles_scroll()
		scroll_bar_styles_scroll = value
		self.emit_changed()

@export var scroll_bar_styles_scroll_focus: StyleBox = self._get_default_scroll_bar_styles_scroll_focus():
	set(value):
		if value == null:
			value = self._get_default_scroll_bar_styles_scroll_focus()
		scroll_bar_styles_scroll_focus = value
		self.emit_changed()

@export var scroll_bar_styles_grabber: StyleBox = self._get_default_scroll_bar_styles_grabber():
	set(value):
		if value == null:
			value = self._get_default_scroll_bar_styles_grabber()
		scroll_bar_styles_grabber = value
		self.emit_changed()

@export var scroll_bar_styles_grabber_highlight: StyleBox = self._get_default_scroll_bar_styles_grabber_highlight():
	set(value):
		if value == null:
			value = self._get_default_scroll_bar_styles_grabber_highlight()
		scroll_bar_styles_grabber_highlight = value
		self.emit_changed()

@export var scroll_bar_styles_grabber_pressed: StyleBox = self._get_default_scroll_bar_styles_grabber_pressed():
	set(value):
		if value == null:
			value = self._get_default_scroll_bar_styles_grabber_pressed()
		scroll_bar_styles_grabber_pressed = value
		self.emit_changed()

@export_subgroup("Constants", "scroll_bar_constants_")

@export var scroll_bar_constants_padding_left: float = 0.0:
	set(value):
		scroll_bar_constants_padding_left = value
		self.emit_changed()

@export var scroll_bar_constants_padding_right: float = 0.0:
	set(value):
		scroll_bar_constants_padding_right = value
		self.emit_changed()


func _get_default_header_background_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color("242424")
	return default_stylebox


func _get_default_header_vertical_separator_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxLine = StyleBoxLine.new()
	default_stylebox.color = Color(0.4, 0.4, 0.4, 1.0)
	default_stylebox.grow_begin = 0.0
	default_stylebox.grow_end = 0.0
	default_stylebox.vertical = true
	return default_stylebox


func _get_default_header_horizontal_separator_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxLine = StyleBoxLine.new()
	default_stylebox.color = Color(0.4, 0.4, 0.4, 1.0)
	default_stylebox.grow_begin = 0.0
	default_stylebox.grow_end = 0.0
	return default_stylebox


func _get_default_header_cell_background_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color("242424")
	return default_stylebox


func _get_default_row_background_styleboxs() -> Array[StyleBox]:
	var default_stylebox1: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox1.bg_color = Color(0.2, 0.2, 0.2, 1.0)
	var default_stylebox2: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox2.bg_color = Color(0.25, 0.25, 0.25, 1.0)
	return [default_stylebox1, default_stylebox2]


func _get_default_row_hover_background_styleboxs() -> Array[StyleBox]:
	var default_stylebox1: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox1.bg_color = Color(0.3, 0.3, 0.3, 1.0)
	var default_stylebox2: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox2.bg_color = Color(0.35, 0.35, 0.35, 1.0)
	return [default_stylebox1, default_stylebox2]


func _get_default_row_vertical_separator_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxLine = StyleBoxLine.new()
	default_stylebox.color = Color(0.4, 0.4, 0.4, 1.0)
	default_stylebox.grow_begin = 0.0
	default_stylebox.grow_end = 0.0
	default_stylebox.vertical = true
	return default_stylebox


func _get_default_row_horizontal_separator_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxLine = StyleBoxLine.new()
	default_stylebox.color = Color(0.4, 0.4, 0.4, 1.0)
	default_stylebox.grow_begin = 0.0
	default_stylebox.grow_end = 0.0
	return default_stylebox

func _get_default_row_cell_background_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxEmpty = StyleBoxEmpty.new()
	return default_stylebox


func _get_default_row_cell_hover_background_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxEmpty = StyleBoxEmpty.new()
	return default_stylebox


func _get_default_boolean_cell_true_icon() -> Texture:
	return load("res://addons/table_plus/icons/true.svg")


func _get_default_boolean_cell_false_icon() -> Texture:
	return load("res://addons/table_plus/icons/false.svg")


func _get_default_scroll_bar_styles_scroll() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color(0.1, 0.1, 0.1, 0.6)
	default_stylebox.content_margin_left = 4.0
	default_stylebox.content_margin_right = 4.0
	return default_stylebox


func _get_default_scroll_bar_styles_scroll_focus() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color(1.0, 1.0, 1.0, 0.75)
	default_stylebox.content_margin_left = 4.0
	default_stylebox.content_margin_top = 4.0
	default_stylebox.content_margin_right = 4.0
	default_stylebox.content_margin_bottom = 4.0
	default_stylebox.expand_margin_left = 2.0
	default_stylebox.expand_margin_top = 2.0
	default_stylebox.expand_margin_right = 2.0
	default_stylebox.expand_margin_bottom = 2.0
	return default_stylebox


func _get_default_scroll_bar_styles_grabber() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color(1.0, 1.0, 1.0, 0.4)
	default_stylebox.content_margin_left = 4.0
	default_stylebox.content_margin_top = 4.0
	default_stylebox.content_margin_right = 4.0
	default_stylebox.content_margin_bottom = 4.0
	return default_stylebox


func _get_default_scroll_bar_styles_grabber_highlight() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color(1.0, 1.0, 1.0, 0.4)
	default_stylebox.corner_radius_top_left = 10.0
	default_stylebox.corner_radius_top_right = 10.0
	default_stylebox.corner_radius_bottom_left = 10.0
	default_stylebox.corner_radius_bottom_right = 10.0
	default_stylebox.content_margin_left = 4.0
	default_stylebox.content_margin_top = 4.0
	default_stylebox.content_margin_right = 4.0
	default_stylebox.content_margin_bottom = 4.0
	return default_stylebox


func _get_default_scroll_bar_styles_grabber_pressed() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color(0.75, 0.75, 0.75, 0.75)
	default_stylebox.corner_radius_top_left = 10.0
	default_stylebox.corner_radius_top_right = 10.0
	default_stylebox.corner_radius_bottom_left = 10.0
	default_stylebox.corner_radius_bottom_right = 10.0
	default_stylebox.content_margin_left = 4.0
	default_stylebox.content_margin_top = 4.0
	default_stylebox.content_margin_right = 4.0
	default_stylebox.content_margin_bottom = 4.0
	return default_stylebox

func _get_default_progress_cell_progress_bar_background_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color(0.1, 0.1, 0.1, 0.3)
	return default_stylebox


func _get_default_progress_cell_progress_bar_fill_stylebox() -> StyleBox:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.bg_color = Color(1.0, 1.0, 1.0, 0.4)
	return default_stylebox
