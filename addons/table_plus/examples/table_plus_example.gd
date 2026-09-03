extends Control


func _ready() -> void:
	$TablePlus.set_data([
		["123456", "John Doe", "This is a sample description."],
		["567890", "Jane Smith", "Another description goes here."],
		["345678", "Foo Bar", "Yet another description."],
		["901234", "Alice Johnson", "More sample text."],
		["789012", "Bob Brown", "Final description example."],
		["456789", "Charlie Black", "Another example description."],
		["234567", "David White", "Sample description for David."],
		["890123", "Eve Davis", "Description for Eve."],
		["678901", "Frank Miller", "Description for Frank."],
		["567890", "Grace Lee", "Description for Grace."]
	] as Array[Array])
	$TablePlus.row_clicked.connect(func(row_index: int, row: TableRow):
		print("Clicked row index: ", row_index, ", row: ", row)
	)
	$TablePlus.cell_clicked.connect(func(row_index: int, column_index: int, cell: TableCell):
		print("Clicked cell at row ", row_index, ", column ", column_index, ": ", cell.content)
	)
	
