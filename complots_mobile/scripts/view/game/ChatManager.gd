extends Control

export(String) var player_username: String = "Username"
export(Color) var player_color: Color = Color("#000000")
export(Texture) var base_texture = null
export(Texture) var base_texture_hover = null
export(Texture) var notification_texture = null
export(Texture) var notification_texture_hover = null

onready var toggle_chat_button: Button = $Chat_Button
onready var chat_text: RichTextLabel = $Background/Chat_Text_Container/MarginContainer/Chat_Text
onready var user_input: TextEdit = $Background/Chat_Text_Container/User_Text_Input_Container_Background/MarginContainer/User_Text_Input_Container/User_Text_Input_Background/MarginContainer/User_Text_Input
onready var send_button: Button = $Background/Chat_Text_Container/User_Text_Input_Container_Background/MarginContainer/User_Text_Input_Container/Send_Button


var is_chat_open: bool = false
var chat_width: int = self.rect_size[0]
var game_manager: Node = null
var _ret # To Stop Warnings


func _ready():
	_ret = toggle_chat_button.connect("pressed", self, '_on_Chat_Button_pressed')
	_ret = send_button.connect("pressed", self, '_on_Send_Button_pressed', [user_input])
	_ret = user_input.connect("text_changed", self, '_on_User_Input_changed', [user_input])


func toggle_chat() -> void:
	is_chat_open = !is_chat_open
	update_chat_button_state()
	var move_offset: int = chat_width if is_chat_open else -chat_width
	rect_position = rect_position - Vector2(move_offset, 0)
	if is_chat_open:
		set_visual_base()
	if game_manager:
		game_manager.move_screen(move_offset)
		game_manager._on_chat_toggled()


func open_chat() -> void:
	is_chat_open = true
	set_visual_base()
	update_chat_position()


func close_chat() -> void:
	is_chat_open = false
	update_chat_position()


func update_chat_position() -> void:
	update_chat_button_state()
	var move_offset: int = chat_width if is_chat_open else 0
	rect_position = Vector2(get_viewport_rect().size[0] - move_offset, 0)
	if game_manager:
		game_manager.move_screen(move_offset)
		game_manager._on_chat_toggled()



func update_chat_button_state() -> void:
	toggle_chat_button.pressed = is_chat_open


func _on_Chat_Button_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	toggle_chat()


func _on_Send_Button_pressed(_user_input: TextEdit) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	if !_user_input or _user_input.text == "":
		_user_input.text = ""
		return
	var user_msg: String = ""
	if chat_text.text != "":
		user_msg = "\n"
	
	if AppManager.is_singleplayer:
		user_msg += "[b][color=#%s]%s:[/color][/b] " % [player_color.to_html(), player_username]
		user_msg += user_input.text
		_ret = chat_text.append_bbcode(user_msg)
	else:
		Network.update_chat({"player_id": AppManager.player_game_id, "message": user_input.text})
	_user_input.text = ""


func _on_User_Input_changed(_user_input: TextEdit) -> void:
	var last_char_index: int = len(_user_input.text) - 1
	if last_char_index >= 0 and _user_input.text[last_char_index] == "\n":
		if !_user_input or _user_input.text == "":
			_user_input.text = ""
			return
		_user_input.text[last_char_index] = ""
		_on_Send_Button_pressed(_user_input)


func _on_update_chat(message: String) -> void:
	add_message(message)


# Called from GameManager
func add_message(message: String) -> void:
	if chat_text.text != "":
		message = "\n" + message
	_ret = chat_text.append_bbcode(message)
	if !is_chat_open:
		set_visual_notification()


func set_visual_notification() -> void:
	toggle_chat_button.texture_normal = notification_texture
	toggle_chat_button.texture_hover = notification_texture_hover


func set_visual_base() -> void:
	toggle_chat_button.texture_normal = base_texture
	toggle_chat_button.texture_hover = base_texture_hover
