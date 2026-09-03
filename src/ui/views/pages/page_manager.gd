@tool
class_name PageManager extends Control

var current_page: Control

@export var load_page: String


func _ready() -> void:
    if load_page:
        show_page(load_page)

func show_page(page_name: String) -> void:
    var path := "res://src/ui/views/pages/%s/%s.tscn" % [page_name, page_name]

    if not ResourceLoader.exists(path):
        printerr("Page '%s' was not found" % page_name)
        return

    if current_page:
        current_page.queue_free()

    var page := load(path).instantiate() as Control

    if page == null:
        printerr("Page '%s' is not a Control" % page_name)
        return

    add_child(page)
    page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    current_page = page