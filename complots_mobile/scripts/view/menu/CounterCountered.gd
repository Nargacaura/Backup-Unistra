extends RichTextLabel

export(int, FLAGS, "Assassin", "Captain", "Duke", "Contessa", "Ambassador", "Inquisitor", "Foreign Aid") var counter = 0
export(int, FLAGS, "Assassin", "Captain", "Duke", "Contessa", "Ambassador", "Inquisitor") var countered_by = 0
export(bool) var begin_with_blank_line: bool = false


func _ready():
	update_text()
	var _ret = Localization.connect("update_lang", self, "update_text")


func update_text() -> void:
	var counter_text: String = make_roles_string(counter)
	var countered_by_text: String = make_roles_string(countered_by)
	bbcode_text = "\n" if begin_with_blank_line else ""
	bbcode_text += "[color=#706fd3][b]%s:[/b][/color] %s." % [Localization.get("menu.rules.counter"), counter_text]
	bbcode_text += "\n[color=#706fd3][b]%s:[/b][/color] %s." % [Localization.get("menu.rules.countered_by"), countered_by_text]


func make_roles_string(flags: int) -> String:
	var roles: String = ""
	
	if flags == 0:
		roles += Localization.get("none")
	if is_bit_enabled(flags, 0):
		if roles != "":
			roles += ", "
		roles += Localization.get("character.assassin")
	if is_bit_enabled(flags, 1):
		if roles != "":
			roles += ", "
		roles += Localization.get("character.captain")
	if is_bit_enabled(flags, 2):
		if roles != "":
			roles += ", "
		roles += Localization.get("character.duke")
	if is_bit_enabled(flags, 3):
		if roles != "":
			roles += ", "
		roles += Localization.get("character.contessa")
	if is_bit_enabled(flags, 4):
		if roles != "":
			roles += ", "
		roles += Localization.get("character.ambassador")
	if is_bit_enabled(flags, 5):
		if roles != "":
			roles += ", "
		roles += Localization.get("character.inquisitor")
	if is_bit_enabled(flags, 6):
		if roles != "":
			roles += ", "
		roles += Localization.get("action.foreign_aid")
	
	return roles


func is_bit_enabled(mask, index):
	return mask & (1 << index) != 0
