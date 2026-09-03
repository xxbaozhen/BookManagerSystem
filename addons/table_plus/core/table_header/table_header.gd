@tool
class_name TableHeader
extends PanelContainer


signal header_cell_sorted(cell_id: String, sort_state: TableGlobals.SortState)


const TABLE_HEADER_CELL = preload("uid://stchjotskrjc")


var _current_theme: TablePlusTheme = null
var _separators_visible: bool = true: set = set_separators_visible


func _ready() -> void:
	self.resized.connect(self._on_resized)


## 添加表头单元格
func add_cell(cell_resource: TableHeaderCellResource) -> void:
	if cell_resource == null:
		return
	var cell: TableHeaderCell = TABLE_HEADER_CELL.instantiate()
	cell.initialize(cell_resource, %CellsHBoxContainer)
	cell.update_theme(self._current_theme)
	cell.clicked.connect(self._on_cell_clicked)
	self.update_separators.call_deferred()


## 删除表头单元格
func remove_cell(cell: TableHeaderCell) -> void:
	if cell == null:
		return
	%CellsHBoxContainer.remove_child(cell)
	if cell.clicked.is_connected(self._on_cell_clicked):
		cell.clicked.disconnect(self._on_cell_clicked)
	cell.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	self.update_separators.call_deferred()


## 清空表头单元格
func clear_cells() -> void:
	for cell: TableHeaderCell in %CellsHBoxContainer.get_children():
		%CellsHBoxContainer.remove_child(cell)
		if cell.clicked.is_connected(self._on_cell_clicked):
			cell.clicked.disconnect(self._on_cell_clicked)
		cell.queue_free()
	self.update_separators.call_deferred()


## 获取表头单元格
func get_cells() -> Array[TableHeaderCell]:
	var return_array: Array[TableHeaderCell] = []
	for cell in %CellsHBoxContainer.get_children():
		if cell is TableHeaderCell:
			return_array.append(cell)
	return return_array


## 获取分割线（副本）
func get_separators() -> Array[Control]:
	var separators: Array[Control] = []
	var cells: Array = %CellsHBoxContainer.get_children()
	for i in range(cells.size()):
		var cell: TableHeaderCell = cells[i]
		if i == 0:
			continue
		var separator: Control = cell.get_separator().duplicate()
		separator.position = cell.position
		separators.append(separator)
	return separators


func update_theme(theme: TablePlusTheme) -> void:
	self._current_theme = theme
	self.add_theme_stylebox_override("panel", theme.header_background_stylebox)
	for separator: Control in %SeparatorContainer.get_children():
		separator.add_theme_stylebox_override("panel", theme.header_vertical_separator_stylebox)


func set_separators_visible(visible: bool) -> void:
	_separators_visible = visible
	for separator: Control in %SeparatorContainer.get_children():
		separator.visible = _separators_visible
	self.update_separators()


## 更新分割线
func update_separators() -> void:
	var cells: Array = %CellsHBoxContainer.get_children()
	for i in range(cells.size()):
		var cell: TableHeaderCell = cells[i]
		var separator_visible: bool = self._separators_visible
		if i == 0:
			separator_visible = false
		cell.update_separator(separator_visible)


func _on_cell_clicked(cell_id: String) -> void:
	var index: int = %CellsHBoxContainer.get_children().find_custom(func(cell: TableHeaderCell) -> bool:
		return cell.id == cell_id)
	var cur_cell: TableHeaderCell = %CellsHBoxContainer.get_child(index)
	if cur_cell == null or not cur_cell.sortable:
		return
	# 确保只有一个单元格处于排序状态
	for cell: TableHeaderCell in %CellsHBoxContainer.get_children():
		if cell.id != cell_id and cell.sort_state != TableGlobals.SortState.NONE:
			cell.set_sort_state(TableGlobals.SortState.NONE)
	self.header_cell_sorted.emit(cell_id, cur_cell.sort_state)


func _on_resized() -> void:
	self.update_separators()
