class_name TableCellFactory


const TEXT_TABLE_CELL = preload("uid://3dipo7cpmkmo")
const NUMBER_TABLE_CELL = preload("uid://b7pa4pgpvifai")
const CURRENCY_TABLE_CELL = preload("uid://dgkw4adr7bhcx")
const PERCENTAGE_TABLE_CELL = preload("uid://bb65q572lly2t")
const DATE_TABLE_CELL = preload("uid://c1ts3afp63620")
const BOOLEAN_TABLE_CELL = preload("uid://mc55jjsc2egq")
const PROGRESS_TABLE_CELL = preload("uid://bx557lgmt1erx")


static func create_table_cell(type: TableGlobals.CellType) -> TableCell:
	match type:
		TableGlobals.CellType.TEXT:
			var cell: TableCell = TEXT_TABLE_CELL.instantiate()
			return cell
		TableGlobals.CellType.NUMBER:
			var cell: TableCell = NUMBER_TABLE_CELL.instantiate()
			return cell
		TableGlobals.CellType.CURRENCY:
			var cell: TableCell = CURRENCY_TABLE_CELL.instantiate()
			return cell
		TableGlobals.CellType.PERCENTAGE:
			var cell: TableCell = PERCENTAGE_TABLE_CELL.instantiate()
			return cell
		TableGlobals.CellType.DATE:
			var cell: TableCell = DATE_TABLE_CELL.instantiate()
			return cell
		TableGlobals.CellType.BOOLEAN:
			var cell: TableCell = BOOLEAN_TABLE_CELL.instantiate()
			return cell
		TableGlobals.CellType.PROGRESS:
			var cell: TableCell = PROGRESS_TABLE_CELL.instantiate()
			return cell
		_:
			var cell: TableCell = TEXT_TABLE_CELL.instantiate()
			return cell
