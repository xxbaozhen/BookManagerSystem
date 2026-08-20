@tool
extends Node

@export var icon_name: String

func _ready() -> void:
	if self["text"] is String:
		self["text"] = FontIconUtil.code_point_to_text(icon_name)
