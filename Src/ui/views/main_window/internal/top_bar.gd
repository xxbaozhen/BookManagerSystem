extends PanelContainer

@onready var info: HBoxContainer = $HBoxContainer/CenterContent/HBoxContainer
@export var menu: PopupPanel

func _gui_input(event: InputEvent) -> void:
	# 拖拽处理
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_window().start_drag()

func _ready() -> void:
	info.connect("gui_input", 
		func(event: InputEvent) -> void:
			if event is InputEventMouseButton and event.pressed:
				if event.button_index == MOUSE_BUTTON_LEFT:
					show_popup_menu(event)
	)

func show_popup_menu(event: InputEvent) -> void:
	# 1. 先计算在游戏窗口内部的理想位置（info 的左下角）
	var local_pos = info.global_position + Vector2(0.0, info.size.y)
	
	# 2. 检查项目设置中是否开启了“嵌入子窗口 (Embed Subwindows)”
	# 如果开启了（通常在移动端或 Web 端），Popup 只是一个普通的 CanvasItem，直接用局部坐标即可
	if ProjectSettings.get_setting("display/window/subwindows/embed_subwindows"):
		menu.position = Vector2i(local_pos)
	else:
		# 如果没开启（默认桌面端，Popup 是个独立 OS 窗口），需要转换成屏幕绝对坐标
		var window_screen_pos = Vector2(get_window().position) # 主窗口在屏幕上的位置
		var final_screen_pos = window_screen_pos + local_pos
		menu.position = Vector2(final_screen_pos)
	
	# 3. 弹出菜单
	menu.popup()
