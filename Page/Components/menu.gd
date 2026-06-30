extends MarginContainer

var selected_item = null
@onready var content: VBoxContainer = $VBoxContainer

func _ready():
	# 遍历并绑定点击事件，检查编辑器中是否已预设了选中的项
	for child in content.get_children():
		child.gui_input.connect(_on_item_clicked.bind(child))
		if child.state == MenuButtonState.state.Selected:
			if selected_item == null:
				selected_item = child
			else:
				child.state = MenuButtonState.state.Normal
	
	# 没有任何项被预设为 Selected，默认选中第一个
	if selected_item == null and content.get_child_count() > 0:
		var first_item = content.get_child(0)
		first_item.state = MenuButtonState.state.Selected
		selected_item = first_item

func _on_item_clicked(event: InputEvent, item: Control):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_item == item: return
		if item.state == MenuButtonState.state.Disabled: return
		
		if selected_item:
			selected_item.state = MenuButtonState.state.Normal
			
		selected_item = item
		selected_item.state = MenuButtonState.state.Selected
		
		print("当前选中: ", item.text)
