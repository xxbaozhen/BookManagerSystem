@tool
class_name PageManager extends Control

var current_page: Control

@export var load_page: String


func _ready() -> void:
    # 先连接信号，保证后续菜单点击的页面切换都能收到
    MenuButtonState.page_selected.connect(show_page)
    # 初始页面：直接加载默认页。
    # 不能依赖菜单在 _ready() 里发信号——菜单节点比 PageManager 先就绪，
    # 且首页按钮在场景中已预选（state=SELECTED），菜单启动时根本不会 emit。
    if load_page:
        show_page(load_page)

func show_page(page_name: String) -> void:
    if page_name == "home":
        page_name = "dashboard"
    
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