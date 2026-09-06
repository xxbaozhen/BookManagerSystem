@tool
class_name PageManager extends Control

var current_page: Control
const PAGE_PATH: String = "res://src/ui/views/pages/%s/%s.tscn"

@export var load_page: String


func _ready() -> void:
    MenuButtonState.page_selected.connect(show_page)

    if load_page:  
        show_page(load_page)

func show_page(page_name: String) -> void:
    if page_name == "home":
        page_name = "dashboard"
    
    var path := PAGE_PATH % [page_name, page_name]

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