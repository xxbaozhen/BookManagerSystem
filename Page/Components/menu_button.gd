@tool # 测试需求，发布需删除

extends Control

# 初始化 按钮模板
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var icon: TextureRect = $MarginContainer/HBoxContainer/Icon
@export var text: String = "测试文本":
	set(value):
		text = value
		if is_node_ready():
			label.text = value
@export var m_icon: Texture2D:
	set(value):
		m_icon = value
		if is_node_ready():
			icon.texture = value

# 初始化
func _ready():
	label.text = text
	icon.texture = m_icon
