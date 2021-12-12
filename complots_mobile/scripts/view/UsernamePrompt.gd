extends ColorRect

export(int) var username_min_lenght = 4
export(int) var username_max_lenght = 16

onready var line_edit: LineEdit = $Panel/CenterContainer/VBoxContainer/LineEdit
onready var alert: LineEdit = $Panel/CenterContainer/VBoxContainer/Alert
onready var submit_button: Button = $Panel/CenterContainer/VBoxContainer/CenterContainer/SubmitButton

var forbidden_characters: Array = [" ", "\n", "\t", "\\"]

var _ret # To Stop Warnings


func _ready():
	_ret = submit_button.connect("pressed", self, "_on_SubmitButton_pressed")
	_ret = line_edit.connect("text_entered", self, "_on_LineEdit_text_entered")
	line_edit.grab_focus()


func _on_SubmitButton_pressed() -> void:
	validate_user_input(line_edit.text)


func _on_LineEdit_text_entered(user_text: String) -> void:
	validate_user_input(user_text)


func validate_user_input(user_text: String) -> void:
	if user_text == "":
		alert.text = Localization.get("menu.input_empty")
		return
	
	if len(user_text) < username_min_lenght:
		alert.text = Localization.get("menu.username_too_short")
		return
	
	if len(user_text) > username_max_lenght:
		alert.text = Localization.get("menu.username_too_long")
		return
	
	for forbidden_char in forbidden_characters:
		if forbidden_char in user_text:
			alert.text = "%s\n%s: [A-Z,a-z,0-9,-,_]" % [Localization.get("menu.invalid_char"), Localization.get("menu.allowed_char")]
			return
	
	alert.text = ""
	AppManager.set_username(user_text)
	hide()
	queue_free()
