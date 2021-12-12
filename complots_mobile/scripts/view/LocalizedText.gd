tool
extends Node
class_name LocalizedText

export(String) var text_key = ""


func _ready():
	if Engine.is_editor_hint():
		return
	
	var _ret = Localization.connect("update_lang", self, "update_text")
	
	update_text()


func update_text() -> void:
	if text_key and text_key != "":
		var parent: Node = get_parent()
		if parent and "placeholder_text" in parent:
			parent.placeholder_text = Localization.get(text_key)
		elif parent and "text" in parent:
			parent.text = Localization.get(text_key)
