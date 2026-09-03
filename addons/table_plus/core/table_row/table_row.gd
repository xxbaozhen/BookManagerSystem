@tool
class_name TableRow
extends PanelContainer


signal clicked()
signal cell_clicked(column_index: int, cell: TableCell)


var _current_theme: TablePlusTheme = null
var _stylebox_index: int = 0


func _ready() -> void:
	self.mouse_entered.connect(self._on_mouse_entered)
	self.mouse_exited.connect(self._on_mouse_exited)
	self.gui_input.connect(self._on_gui_input)


## 设置数据
func set_data(row_data: Array[TableCell.CellConfig], root: TableRoot) -> void:
	# 清空单元格
	for cell: TableCell in self.get_cells():
		%CellsHBoxContainer.remove_child(cell)
		cell.queue_free()
	
	# 添加单元格
	var index: int = 0
	for cell_config: TableCell.CellConfig in row_data:
		var cell: TableCell = TableCellFactory.create_table_cell(cell_config.type)
		cell.content = cell_config.content
		cell.horizontal_alignment = cell_config.horizontal_alignment
		cell.vertical_alignment = cell_config.vertical_alignment
		cell.width_ratio = cell_config.width_ratio
		cell.overflow_mode = cell_config.overflow_mode
		cell.apply_other_config(root)
		cell.update_theme(self._current_theme)
		cell.clicked.connect(func(): self.cell_clicked.emit(index, cell))
		%CellsHBoxContainer.add_child(cell)
		index += 1


## 更新垂直分割线
func update_vertical_separators(separators: Array[Control], is_show: bool) -> void:
	# print("Update Vertical Separators: ", is_show)
	for separator: Control in %SeparatorContainer.get_children():
		%SeparatorContainer.remove_child(separator)
		separator.queue_free()
	if not is_show:
		return
	for separator: Control in separators:
		var new_separator: Control = separator.duplicate()
		if self._current_theme != null:
			new_separator.add_theme_stylebox_override("panel", self._current_theme.row_vertical_separator_stylebox)
		new_separator.custom_minimum_size.y = self.custom_minimum_size.y
		new_separator.visible = true
		%SeparatorContainer.add_child(new_separator)


## 更新水平分割线
func update_horizontal_separators(is_show: bool, offset: float) -> void:
	if not is_show:
		%HorizontalSeparator.visible = false
		return
	%HorizontalSeparator.visible = true
	%HorizontalSeparator.position.y = offset
	if self._current_theme != null:
		%HorizontalSeparator.add_theme_stylebox_override("panel", self._current_theme.row_horizontal_separator_stylebox)


## 获取单元格
func get_cells() -> Array[TableCell]:
	var return_array: Array[TableCell] = []
	for cell in %CellsHBoxContainer.get_children():
		if cell is TableCell:
			return_array.append(cell)
	return return_array


func update_theme(theme: TablePlusTheme) -> void:
	self._current_theme = theme
	for separator: Control in %SeparatorContainer.get_children():
		separator.add_theme_stylebox_override("panel", theme.row_vertical_separator_stylebox)
	%HorizontalSeparator.add_theme_stylebox_override("panel", theme.row_horizontal_separator_stylebox)


func set_background_stylebox(index: int) -> void:
	if self._current_theme == null:
		return
	self._stylebox_index = 0
	if self._current_theme.row_enable_zebra_stripes:
		self._stylebox_index = index % self._current_theme.row_background_styleboxs.size()
	self.add_theme_stylebox_override("panel", self._current_theme.row_background_styleboxs[self._stylebox_index])


func _on_mouse_entered() -> void:
	# 更新背景样式
	if self._current_theme != null:
		self.add_theme_stylebox_override("panel", self._current_theme.row_hover_background_stylebox[self._stylebox_index])


func _on_mouse_exited() -> void:
	# 恢复背景样式
	if self._current_theme != null:
		self.add_theme_stylebox_override("panel", self._current_theme.row_background_styleboxs[self._stylebox_index])


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			self.clicked.emit()
