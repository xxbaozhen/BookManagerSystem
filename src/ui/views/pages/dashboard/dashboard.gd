extends PanelContainer

## 最近借阅表格数据（TablePlus 的 preview_data 仅在编辑器中可见，运行时需通过 set_data 注入）
const BORROW_ROWS: Array[Array] = [
	["三体", "张三", "2026-08-20", "2026-09-10", "借出中"],
	["活着", "李四", "2026-08-18", "2026-09-08", "已归还"],
	["百年孤独", "王五", "2026-08-25", "2026-09-15", "已逾期"],
]

## 最近上新表格数据
const NEW_BOOK_ROWS: Array[Array] = [
	["三体", "刘慈欣", "2026-08-28"],
	["活着", "余华", "2026-08-22"],
	["百年孤独", "加西亚·马尔克斯", "2026-08-15"],
]


func _ready() -> void:
	# TablePlus 不会把序列化的 title_visible 应用到内部节点，需在运行时再设置一次以隐藏标题
	%BorrowTable.title_visible = false
	%BookList.title_visible = false
	%BorrowTable.set_data(BORROW_ROWS)
	%BookList.set_data(NEW_BOOK_ROWS)
