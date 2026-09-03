@tool
class_name ProgressTableCell
extends TableCell


var fill_mode: ProgressBar.FillMode = ProgressBar.FillMode.FILL_BEGIN_TO_END: set = set_fill_mode
var show_percentage: bool = true: set = set_show_percentage


func _ready() -> void:
	super._ready()
	%ContentProgressBar.min_value = 0.0
	%ContentProgressBar.max_value = 100.0


func get_content_control() -> Control:
	return %ContentProgressBar


func set_content(value: Variant) -> void:
	content = value
	%ContentProgressBar.value = float(value)


func set_horizontal_alignment(alignment: int) -> void:
	pass


func set_vertical_alignment(alignment: int) -> void:
	pass


func apply_other_config(root: TableRoot) -> void:
	super.apply_other_config(root)
	self.fill_mode = root.progress_cell_fill_mode
	self.show_percentage = root.progress_cell_show_percentage


func update_theme(theme: TablePlusTheme) -> void:
	super.update_theme(theme)
	var progress_cell_background_stylebox: StyleBox = self._current_theme.row_cell_background_stylebox
	if self._current_theme.progress_cell_background_stylebox != null and not self._current_theme.progress_cell_background_stylebox is StyleBoxEmpty:
		progress_cell_background_stylebox = self._current_theme.progress_cell_background_stylebox
	self.add_theme_stylebox_override("panel", progress_cell_background_stylebox)
	%ContentProgressBar.add_theme_color_override("font_color", self._current_theme.progress_cell_progress_bar_font_color)
	%ContentProgressBar.add_theme_color_override("font_outline_color", self._current_theme.progress_cell_progress_bar_font_outline_color)
	%ContentProgressBar.add_theme_constant_override("outline_size", self._current_theme.progress_cell_progress_bar_outline_size)
	%ContentProgressBar.add_theme_font_size_override("font_size", self._current_theme.progress_cell_progress_bar_font_size)
	var progress_bar_font: Font = self._current_theme.progress_cell_progress_bar_font \
			if self._current_theme.progress_cell_progress_bar_font != null else self.get_theme_default_font()
	%ContentProgressBar.add_theme_font_override("font", progress_bar_font)
	%ContentProgressBar.add_theme_stylebox_override("background", self._current_theme.progress_cell_progress_bar_background)
	%ContentProgressBar.add_theme_stylebox_override("fill", self._current_theme.progress_cell_progress_bar_fill)



func compare_values(value_a: Variant, value_b: Variant, sort_state: TableGlobals.SortState) -> bool:
	var progress_a: float = float(value_a)
	var progress_b: float = float(value_b)
	match sort_state:
		TableGlobals.SortState.ASC:
			return progress_a < progress_b
		TableGlobals.SortState.DESC:
			return progress_a > progress_b
		_:
			return false


func set_fill_mode(new_mode: ProgressBar.FillMode) -> void:
	fill_mode = new_mode
	%ContentProgressBar.fill_mode = fill_mode


func set_show_percentage(visible: bool) -> void:
	show_percentage = visible
	%ContentProgressBar.show_percentage = show_percentage


func _handle_overflow() -> void:
	pass


func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	var progress_cell_hover_background_stylebox: StyleBox = self._current_theme.row_cell_hover_background_stylebox
	if self._current_theme.progress_cell_hover_background_stylebox != null and not self._current_theme.progress_cell_hover_background_stylebox is StyleBoxEmpty:
		progress_cell_hover_background_stylebox = self._current_theme.progress_cell_hover_background_stylebox
	self.add_theme_stylebox_override("panel", progress_cell_hover_background_stylebox)



func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	var progress_cell_background_stylebox: StyleBox = self._current_theme.row_cell_background_stylebox
	if self._current_theme.progress_cell_background_stylebox != null and not self._current_theme.progress_cell_background_stylebox is StyleBoxEmpty:
		progress_cell_background_stylebox = self._current_theme.progress_cell_background_stylebox
	self.add_theme_stylebox_override("panel", progress_cell_background_stylebox)
