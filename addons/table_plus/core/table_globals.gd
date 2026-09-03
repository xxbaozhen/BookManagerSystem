class_name TableGlobals


enum CellType {
	## 文本
	TEXT,
	## 数字
	NUMBER,
	## 货币
	CURRENCY,
	## 百分比
	PERCENTAGE,
	## 日期
	DATE,
	## 布尔值
	BOOLEAN,
	## 进度条
	PROGRESS,
}


enum SortState {
	NONE = 0,
	## 升序
	ASC = 1,
	## 降序
	DESC = 2
}


enum OverflowMode {
	## 直接裁剪
	CLIP,
	## 显示省略号
	ELLIPSIS,
}
