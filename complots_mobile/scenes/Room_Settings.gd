extends ColorRect

signal create_room_validated(card_choice, room_name)

onready var back_btn: Button = $CenterContainer/Panel/Content/MarginContainer/SettingsContent/Container/Back
onready var create_btn: Button = $CenterContainer/Panel/Content/MarginContainer/SettingsContent/Create/Button
onready var room_name_line_edit: LineEdit = $CenterContainer/Panel/Content/MarginContainer/SettingsContent/RoomName/LineEdit
onready var error_label: Label = $CenterContainer/Panel/Content/MarginContainer/SettingsContent/Error

onready var ambassador_btn: Button = $CenterContainer/Panel/Content/MarginContainer/SettingsContent/CardChoice/Ambassador/Card/Button
onready var inquisitor_btn: Button = $CenterContainer/Panel/Content/MarginContainer/SettingsContent/CardChoice/Inquisitor/Card/Button

var card_choice: int = Card.CARD_TYPE.AMBASSADOR

func _ready():
	var _ret = back_btn.connect("mouse_entered", self, "_on_BackBtn_entered")
	_ret = back_btn.connect("mouse_exited", self, "_on_BackBtn_exited")
	_ret = back_btn.connect("pressed", self, "_on_BackBtn_pressed")
	_ret = create_btn.connect("pressed", self, "_on_create_btn_pressed")
	
	_ret = ambassador_btn.connect("pressed", self, "_on_choice_changed", [Card.CARD_TYPE.AMBASSADOR])
	_ret = inquisitor_btn.connect("pressed", self, "_on_choice_changed", [Card.CARD_TYPE.INQUISITOR])
	
	clear_fields()
	update_card_visual()


func _on_BackBtn_entered() -> void:
	back_btn.self_modulate = Color("#999999")


func _on_BackBtn_exited() -> void:
	back_btn.self_modulate = Color(1, 1, 1)


func _on_BackBtn_pressed() -> void:
	self.hide()
	self.set_process(false)
	clear_fields()


func _on_choice_changed(card_type: int) -> void:
	card_choice = card_type
	update_card_visual()


func update_card_visual() -> void:
	if card_choice == Card.CARD_TYPE.AMBASSADOR:
		ambassador_btn.pressed = true
		inquisitor_btn.pressed = false
	elif card_choice == Card.CARD_TYPE.INQUISITOR:
		ambassador_btn.pressed = false
		inquisitor_btn.pressed = true


func _on_create_btn_pressed() -> void:
	if card_choice < Card.CARD_TYPE.AMBASSADOR: card_choice = Card.CARD_TYPE.AMBASSADOR
	if card_choice > Card.CARD_TYPE.INQUISITOR: card_choice = Card.CARD_TYPE.INQUISITOR
	
	if room_name_line_edit.text == "":
		error_label.text = Localization.get("menu.room_name_empty")
		return
	
	if len(room_name_line_edit.text) > 16:
		error_label.text = Localization.get("menu.room_name_too_long")
		return
	
	emit_signal("create_room_validated", card_choice, room_name_line_edit.text)
	clear_fields()


func clear_fields() -> void:
	room_name_line_edit.text = ""
	error_label.text = ""
	card_choice = Card.CARD_TYPE.AMBASSADOR
