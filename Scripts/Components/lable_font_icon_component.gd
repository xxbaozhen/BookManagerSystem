extends Label

@export var icon_name: String

func _is_hex_string(input: String) -> bool:
	if input.is_empty(): return false
	var clean_str = input.trim_prefix("0x").trim_prefix("0X")
	if clean_str.is_empty(): return false
	
	for c in clean_str:
		if not (c in "0123456789abcdefABCDEF"):
			return false
	return true
	
func _ready() -> void:
	if _is_hex_string(icon_name):
		var code = icon_name.hex_to_int()
		if code >= 0 and code <= 0x10FFFF:
			text = char(code)
		else:
			text = ""
	else:
		text = ""
