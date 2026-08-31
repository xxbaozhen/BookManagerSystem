@tool
extends Node

@export var icon_name: String
@export var property_name: String = "text"

func _ready() -> void:
	if self[property_name] is String:
		self[property_name] = FontIconUtil.code_point_to_text(icon_name)
