@abstract
class_name TableCell
extends PanelContainer


signal clicked()


## 内容
var content: Variant: set = set_content
## 水平对齐方式
var horizontal_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT: set = set_horizontal_alignment
## 垂直对齐方式
var vertical_alignment: VerticalAlignment = VERTICAL_ALIGNMENT_CENTER: set = set_vertical_alignment
## 宽度比
var width_ratio: float = 1.0: set = set_width_ratio
## 溢出模式
var overflow_mode: TableGlobals.OverflowMode = TableGlobals.OverflowMode.CLIP: set = set_overflow_mode


var _root: TableRoot = null
var _current_theme: TablePlusTheme = null


func _ready() -> void:
	self.mouse_entered.connect(self._on_mouse_entered)
	self.mouse_exited.connect(self._on_mouse_exited)
	self.gui_input.connect(self._on_gui_input)
	self.resized.connect(self._on_resized)


@abstract
func get_content_control() -> Control


@abstract
func set_content(new_content: Variant) -> void


@abstract
func set_horizontal_alignment(alignment: HorizontalAlignment) -> void


@abstract
func set_vertical_alignment(alignment: VerticalAlignment) -> void


func set_width_ratio(ratio: float) -> void:
	width_ratio = ratio
	self.size_flags_stretch_ratio = ratio


func set_overflow_mode(mode: TableGlobals.OverflowMode) -> void:
	overflow_mode = mode
	self._handle_overflow.call_deferred()


func apply_other_config(root: TableRoot) -> void:
	self._root = root
	match self._root.interaction_mode:
		TableRoot.InteractionMode.Row:
			self.mouse_filter = Control.MOUSE_FILTER_IGNORE
		TableRoot.InteractionMode.Cell:
			self.mouse_filter = Control.MOUSE_FILTER_STOP


func update_theme(theme: TablePlusTheme) -> void:
	self._current_theme = theme


@abstract
func compare_values(value_a: Variant, value_b: Variant, sort_state: TableGlobals.SortState) -> bool


@abstract
func _handle_overflow() -> void


func _on_mouse_entered() -> void:
	if self._root == null:
		return
	if self._root.interaction_mode == TableRoot.InteractionMode.Row:
		return


func _on_mouse_exited() -> void:
	if self._root == null:
		return
	if self._root.interaction_mode == TableRoot.InteractionMode.Row:
		return


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			self.clicked.emit()


func _on_resized() -> void:
	self._handle_overflow.call_deferred()


class CellConfig:
	var type: TableGlobals.CellType = TableGlobals.CellType.TEXT
	var content: Variant = null
	var horizontal_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT
	var vertical_alignment: VerticalAlignment = VERTICAL_ALIGNMENT_CENTER
	var width_ratio: float = 1.0
	var overflow_mode: TableGlobals.OverflowMode = TableGlobals.OverflowMode.CLIP
