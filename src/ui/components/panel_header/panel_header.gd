@tool
extends HBoxContainer

@export var title_text: String = "标题":
	set(value):
		title_text = value
		if _ready_called:
			_title_label.text = value

var _ready_called := false

@onready var _title_label: Label = $Title


func _ready() -> void:
	_title_label.text = title_text
	_ready_called = true
