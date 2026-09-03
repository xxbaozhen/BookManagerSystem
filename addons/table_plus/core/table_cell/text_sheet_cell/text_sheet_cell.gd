@tool
class_name TextTableCell
extends TableCell


func _ready() -> void:
	super._ready()
	%ContentRichTextLabel.scroll_active = false
	%ContentRichTextLabel.autowrap_mode = TextServer.AUTOWRAP_OFF


func get_content_control() -> Control:
	return %ContentRichTextLabel


func set_content(new_content: Variant) -> void:
	if new_content == null:
		content = ""
		%ContentRichTextLabel.text = ""
		return
	content = str(new_content)
	%ContentRichTextLabel.text = str(content)


func set_horizontal_alignment(alignment: HorizontalAlignment) -> void:
	horizontal_alignment = alignment
	%ContentRichTextLabel.horizontal_alignment = alignment


func set_vertical_alignment(alignment: VerticalAlignment) -> void:
	vertical_alignment = alignment
	%ContentRichTextLabel.vertical_alignment = alignment


func update_theme(theme: TablePlusTheme) -> void:
	super.update_theme(theme)
	var row_cell_font: Font = theme.row_cell_font if theme.row_cell_font != null else self.get_theme_default_font()
	%ContentRichTextLabel.add_theme_font_override("normal_font", row_cell_font)
	%ContentRichTextLabel.add_theme_font_size_override("normal_font_size", theme.row_cell_font_size)
	%ContentRichTextLabel.add_theme_color_override("default_color", theme.row_cell_font_color)
	var text_cell_background_stylebox: StyleBox = theme.row_cell_background_stylebox
	if theme.text_cell_background_stylebox != null and not theme.text_cell_background_stylebox is StyleBoxEmpty:
		text_cell_background_stylebox = theme.text_cell_background_stylebox
	self.add_theme_stylebox_override("panel", text_cell_background_stylebox)


func compare_values(value_a: Variant, value_b: Variant, sort_state: TableGlobals.SortState) -> bool:
	var str_a: String = str(value_a)
	var str_b: String = str(value_b)
	match sort_state:
		TableGlobals.SortState.ASC:
			return str_a < str_b
		TableGlobals.SortState.DESC:
			return str_a > str_b
		_:
			return false


func _handle_overflow() -> void:
	# 恢复原始文本，以确保每次处理前都是完整文本
	self.set_content(self.content)
	match overflow_mode:
		TableGlobals.OverflowMode.CLIP:
			%ContentRichTextLabel.clip_contents = true
			%ContentRichTextLabel.scroll_active = false
			self.set_content(self.content)
		TableGlobals.OverflowMode.ELLIPSIS:
			var content_width: int = %ContentRichTextLabel.get_content_width()
			var text_label_width: int = %ContentRichTextLabel.size.x
			if content_width > text_label_width:
				var ellipsis_text: String = %ContentRichTextLabel.text
				while %ContentRichTextLabel.get_content_width() > text_label_width and ellipsis_text.length() > 0:
					ellipsis_text = ellipsis_text.substr(0, ellipsis_text.length() - 1)
					%ContentRichTextLabel.text = ellipsis_text + "…"


func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	var text_cell_hover_background_stylebox: StyleBox = self._current_theme.row_cell_hover_background_stylebox
	if self._current_theme.text_cell_hover_background_stylebox != null and not self._current_theme.text_cell_hover_background_stylebox is StyleBoxEmpty:
		text_cell_hover_background_stylebox = self._current_theme.text_cell_hover_background_stylebox
	self.add_theme_stylebox_override("panel", text_cell_hover_background_stylebox)


func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	var text_cell_background_stylebox: StyleBox = self._current_theme.row_cell_background_stylebox
	if self._current_theme.text_cell_background_stylebox != null and not self._current_theme.text_cell_background_stylebox is StyleBoxEmpty:
		text_cell_background_stylebox = self._current_theme.text_cell_background_stylebox
	self.add_theme_stylebox_override("panel", text_cell_background_stylebox)
