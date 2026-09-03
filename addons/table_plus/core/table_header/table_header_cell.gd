@tool
class_name TableHeaderCell
extends PanelContainer


signal clicked(id: String)


var id: String = ""
var title: String = "title": set = set_title
var type: TableGlobals.CellType = TableGlobals.CellType.TEXT
var width_ratio: float = 1.0: set = set_width_ratio
var sortable: bool = true: set = set_sortable
var sort_state: TableGlobals.SortState = TableGlobals.SortState.NONE: set = set_sort_state
var overflow_mode: TableGlobals.OverflowMode = TableGlobals.OverflowMode.CLIP: set = set_overflow_mode
var title_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT: set = set_title_alignment
var content_horizontal_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT: set = set_content_horizontal_alignment
var content_vertical_alignment: VerticalAlignment = VERTICAL_ALIGNMENT_CENTER: set = set_content_vertical_alignment


func _ready() -> void:
	self.title = "TITLE"
	%SortIconsVBoxContainer.hide()
	%AscIconTextureRect.hide()
	%DescIconTextureRect.hide()
	self.gui_input.connect(self._on_gui_input)
	self.resized.connect(self._on_resized)


func initialize(res: TableHeaderCellResource, parent: Control) -> void:
	parent.add_child(self)
	self.title = res.title
	self.id = res.id
	self.type = res.type
	self.width_ratio = res.width_ratio
	self.sortable = res.sortable
	self.sort_state = res.sort_state
	self.overflow_mode = res.overflow_mode
	self.title_alignment = res.title_alignment
	self.content_horizontal_alignment = res.content_horizontal_alignment
	self.content_vertical_alignment = res.content_vertical_alignment
	

func set_title(new_title: String) -> void:
	title = new_title
	%TitleRichTextLabel.text = title


func set_title_alignment(alignment: HorizontalAlignment) -> void:
	title_alignment = alignment
	%TitleRichTextLabel.horizontal_alignment = alignment


func set_width_ratio(ratio: float) -> void:
	width_ratio = ratio
	self.size_flags_stretch_ratio = ratio


func set_sortable(is_sortable: bool) -> void:
	sortable = is_sortable


func set_sort_state(state: TableGlobals.SortState) -> void:
	sort_state = state
	self._handle_sorting()


func set_overflow_mode(mode: TableGlobals.OverflowMode) -> void:
	overflow_mode = mode
	self._handle_overflow.call_deferred()


func set_content_horizontal_alignment(alignment: HorizontalAlignment) -> void:
	content_horizontal_alignment = alignment


func set_content_vertical_alignment(alignment: VerticalAlignment) -> void:
	content_vertical_alignment = alignment


func update_theme(theme: TablePlusTheme) -> void:
	if theme == null:
		return
	if theme.header_cell_background_stylebox != null:
		self.add_theme_stylebox_override("panel", theme.header_cell_background_stylebox)
	if theme.header_cell_font != null:
		%TitleRichTextLabel.add_theme_font_override("normal_font", theme.header_cell_font)
	else:
		%TitleRichTextLabel.add_theme_font_override("normal_font", self.get_theme_default_font())
	%TitleRichTextLabel.add_theme_font_size_override("normal_font_size", theme.header_cell_font_size)
	%TitleRichTextLabel.add_theme_color_override("default_color", theme.header_cell_font_color)
	%Separator.add_theme_stylebox_override("panel", theme.header_vertical_separator_stylebox)
	if theme.header_cell_asc_button_texture != null:
		%AscIconTextureRect.flip_v = false
		%AscIconTextureRect.texture = theme.header_cell_asc_button_texture
	else:
		%AscIconTextureRect.flip_v = false
		%AscIconTextureRect.texture = load("res://addons/table_plus/icons/sort.svg")
	if theme.header_cell_desc_button_texture != null:
		%DescIconTextureRect.flip_v = false
		%DescIconTextureRect.texture = theme.header_cell_desc_button_texture
	else:
		%DescIconTextureRect.flip_v = true
		%DescIconTextureRect.texture = load("res://addons/table_plus/icons/sort.svg")


func get_separator() -> Control:
	var separator: Control = %Separator
	return separator


func update_separator(is_visible: bool) -> void:
	%Separator.visible = is_visible


func _handle_sorting() -> void:
	if not self.sortable:
		return
	
	# 根据 sort_state 进行排序逻辑处理
	match self.sort_state:
		TableGlobals.SortState.NONE:
			%SortIconsVBoxContainer.hide()
			%AscIconTextureRect.hide()
			%DescIconTextureRect.hide()
		TableGlobals.SortState.ASC:
			%SortIconsVBoxContainer.show()
			%AscIconTextureRect.show()
			%DescIconTextureRect.hide()
		TableGlobals.SortState.DESC:
			%SortIconsVBoxContainer.show()
			%AscIconTextureRect.hide()
			%DescIconTextureRect.show()


func _handle_overflow() -> void:
	var title_label: RichTextLabel = %TitleRichTextLabel
	# 恢复原始文本，以确保每次处理前都是完整文本
	title_label.text = title
	match overflow_mode:
		TableGlobals.OverflowMode.CLIP:
			title_label.clip_contents = true
			title_label.scroll_active = false
			title_label.text = title  # 恢复原始文本
		TableGlobals.OverflowMode.ELLIPSIS:
			var content_width: int = title_label.get_content_width()
			var text_label_width: int = title_label.size.x
			# 计算两个宽度并决定是否需要显示省略号
			if content_width > text_label_width:
				var ellipsis_text: String = title_label.text
				while title_label.get_content_width() > text_label_width and ellipsis_text.length() > 0:
					ellipsis_text = ellipsis_text.substr(0, ellipsis_text.length() - 1)
					title_label.text = ellipsis_text + "..."
				# # 按照比例截取字符串并添加省略号
				# var ratio: float = float(text_label_width) / float(content_width)
				# ellipsis_text = ellipsis_text.substr(0, int(ellipsis_text.length() * ratio))
				# # 添加省略号的方式为将最后三个字符替换为省略号，如果字符串过短则直接添加省略号
				# if ellipsis_text.length() > 3:
				# 	ellipsis_text = ellipsis_text.substr(0, ellipsis_text.length() - 3)
				# 	ellipsis_text += "..."
				# else:
				# 	ellipsis_text = "..."
				# title_label.text = ellipsis_text


func _on_gui_input(event: InputEvent) -> void:
	# 处理鼠标点击事件
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 更新排序状态
		self.sort_state = (self.sort_state + 1) % TableGlobals.SortState.size()
		self._handle_overflow.call_deferred()
		self.clicked.emit(self.id)
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		# 右键点击切换模式，测试用
		print("Right click detected on header cell:", self.id)
		if self.overflow_mode == TableGlobals.OverflowMode.CLIP:
			self.overflow_mode = TableGlobals.OverflowMode.ELLIPSIS
		else:
			self.overflow_mode = TableGlobals.OverflowMode.CLIP


func _on_resized() -> void:
	self._handle_overflow.call_deferred()
