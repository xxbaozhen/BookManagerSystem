@tool
class_name TableHeaderCellResource
extends Resource


@export var id: String = "":
	set(value):
		id = value
		self.emit_changed()

@export var title: String = "title":
	set(value):
		title = value
		self.emit_changed()

@export var type: TableGlobals.CellType = TableGlobals.CellType.TEXT:
	set(value):
		type = value
		self.emit_changed()

@export var width_ratio: float = 1.0:
	set(value):
		width_ratio = value
		self.emit_changed()

@export var sortable: bool = true:
	set(value):
		sortable = value
		self.emit_changed()

@export var sort_state: TableGlobals.SortState = TableGlobals.SortState.NONE:
	set(value):
		sort_state = value
		self.emit_changed()

@export var overflow_mode: TableGlobals.OverflowMode = TableGlobals.OverflowMode.CLIP:
	set(value):
		overflow_mode = value
		self.emit_changed()

@export var title_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT:
	set(value):
		title_alignment = value
		self.emit_changed()

@export var content_horizontal_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT:
	set(value):
		content_horizontal_alignment = value
		self.emit_changed()

@export var content_vertical_alignment: VerticalAlignment = VERTICAL_ALIGNMENT_CENTER:
	set(value):
		content_vertical_alignment = value
		self.emit_changed()
