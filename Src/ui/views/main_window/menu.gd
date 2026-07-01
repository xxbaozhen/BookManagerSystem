extends MarginContainer

var selected_item = null
@onready var content: VBoxContainer = $VBoxContainer

func _ready():
	for child in content.get_children():
		child.gui_input.connect(_on_item_clicked.bind(child))
		if child.state == MenuButtonState.state.Selected:
			if selected_item == null:
				selected_item = child
			else:
				child.state = MenuButtonState.state.Normal
	
	if selected_item == null and content.get_child_count() > 0:
		var first_item = content.get_child(0)
		first_item.state = MenuButtonState.state.Selected
		selected_item = first_item

func _on_item_clicked(event: InputEvent, item: Control):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if item.state == MenuButtonState.state.Disabled: return
		
		# 当鼠标左键按下时
		if event.pressed:
			# 如果按下的不是当前已选中的项，赋予按住状态
			if selected_item != item:
				item.state = MenuButtonState.state.Pressed
		
		# 当鼠标左键松开时，才判定为真正的“选中”
		else:
			if selected_item == item: return
			
			if selected_item:
				selected_item.state = MenuButtonState.state.Normal
				
			selected_item = item
			selected_item.state = MenuButtonState.state.Selected
			
			#print("当前选中: ", item.text)
