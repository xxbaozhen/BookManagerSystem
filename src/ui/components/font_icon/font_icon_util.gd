class_name FontIconUtil extends RefCounted

static func code_point_to_text(input: String) -> String:
	var text := ""
	
	if is_hex_string(input):
		var code = input.hex_to_int()
		if code >= 0 and code <= 0x10FFFF:
			text = char(code)
	
	return text

static func is_hex_string(input: String) -> bool:
	if input.is_empty(): return false
	
	var clean_str = input.trim_prefix("0x").trim_prefix("0X")
	
	if clean_str.is_empty(): return false
	
	for c in clean_str:
		if not (c in "0123456789abcdefABCDEF"):
			return false
	return true
