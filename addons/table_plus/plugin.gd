@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree():
	var script = preload("uid://bwolqxek8nbjy")
	var icon = preload("uid://d4ieewusqbjqp")
	self.add_custom_type("TablePlus", "Control", script, icon)
	#self.add_autoload_singleton()

func _exit_tree():
	self.remove_custom_type("TablePlus")
