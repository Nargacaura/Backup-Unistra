extends VBoxContainer

signal back(previous_content, node_self)
onready var back_btn: Button = $PageTitle/Button
var previous_content = null

onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var page_title: Label = $PageTitle/Title
onready var settings_btn: Button = $Grid/Bottom/Settings/Button
onready var start_btn: Button = $Grid/Bottom/Start/Button
onready var start_label: Label = $Grid/Bottom/Start/StartText
onready var chat_text: RichTextLabel = $Grid/Top/CenterColumn/Chat/Content/Content/VBoxContainer/ChatSection/MarginContainer/ChatText
onready var user_input: LineEdit = $Grid/Top/CenterColumn/Chat/Content/Content/VBoxContainer/UserInput/MarginContainer/HBoxContainer/UserInput
onready var send_btn: Button = $Grid/Top/CenterColumn/Chat/Content/Content/VBoxContainer/UserInput/MarginContainer/HBoxContainer/SendButton

onready var players_container: Node = $Grid/Top/LeftColumn/Players/Content/Content/PlayerList
onready var waiting_players_node: Node = $Grid/Top/LeftColumn/Players/Content/Content/PlayerList/WaitingPlayers
var player_item_scene = preload("res://scenes/menu/items/PlayerItemList.tscn")
export(String, FILE) var game_scene = "res://scenes/game/Game.tscn"

export(Texture) var ambassador_sprite = null
export(Texture) var inquisitor_sprite = null
onready var character_sprite_node: TextureRect = $Grid/Top/LeftColumn/Players/Content/Header/Character

var room_name: String = "Room"
var room_id: int = 0
var room_roles: Array = []

var player_id: int = 0
var player_color: Color = Color(1, 1, 1)
var player_username: String = "Username"
var player_count: int = 0
var players_usernames: Array = []
const MAX_PLAYER = 8

var _ret # To Stop Warnings


func _ready():
	_ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	_ret = back_btn.connect("pressed", self, "_on_Back_pressed")
	_ret = start_btn.connect("pressed", self, "_on_Start_pressed")
	_ret = start_btn.connect("mouse_entered", self, "_on_Start_hover", [true])
	_ret = start_btn.connect("mouse_exited", self, "_on_Start_hover", [false])
	_ret = send_btn.connect("pressed", self, "_on_Send_Button_pressed", [user_input])
	_ret = user_input.connect("text_entered", self, '_on_User_Input_changed', [user_input])
	_ret = Network.connect("update_chat", self, '_on_update_chat')
	
	Network.connect_lobby(self)
	
	update_page_title()
	clear_chat()


func _on_window_resize() -> void:
	if get_viewport_rect().size[0] > get_viewport_rect().size[1]:
		$Grid.columns = 2
		$Grid/Bottom.columns = 1
	else:
		$Grid.columns = 1
		$Grid/Bottom.columns = 2


func hide_menu() -> void:
	animation_player.play("hide")
	set_process(false)


func show_menu() -> void:
	set_process(true)
	animation_player.play("show")
	
	set_player_username(AppManager.user_data["login"]["username"])


func _on_Back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	Network.quit_game()
	clear_page()
	emit_signal("back", previous_content, self)


func _on_Start_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	Network.start_game()
	var star_successful = yield(Network, "start_game")
	if star_successful:
		print("Starting Game")
	else:
		print("Error server communication")


func _on_Start_hover(is_hover: bool) -> void:
	if is_hover:
		start_btn.get_parent().modulate = Color(0.6, 0.6, 0.6)
	else:
		start_btn.get_parent().modulate = Color(1, 1, 1)


func _on_Send_Button_pressed(text_input: LineEdit) -> void:
	if !text_input or text_input.text == "":
		return
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	
	Network.update_chat({"player_id": player_id, "message": text_input.text})
	
	text_input.text = ""


func _on_User_Input_changed(_text: String, text_input: LineEdit) -> void:
	_on_Send_Button_pressed(text_input)


func _on_update_chat(data) -> void:
	if !data:
		return
	var text: String = ""
	var _player_id: int = data["player_id"] if data.has("player_id") else -1
	var message: String = data["message"] if data.has("message") else ""
	if chat_text.text != "":
		text = "\n"
	if _player_id != -1:
		text += "[b][color=#%s]%s:[/color][/b] " % [AppManager.players_colors[_player_id - 1].to_html(), players_usernames[_player_id - 1]]
	if message:
		text += "%s" % [message]
	_ret = chat_text.append_bbcode(text)


func set_room_data(_room_id: int, _player_id: int, _room_name: String, _players_usernames: Array, _roles: Array) -> void:
	set_room_id(_room_id)
	set_room_name(_room_name)
	set_player_id(_player_id)
	AppManager.player_game_id = _player_id
	display_welcome_msg()
	set_roles(_roles)
	AppManager.multiplayer_data["roles"] = _roles
	players_usernames = _players_usernames
	
	update_players()


func set_roles(_roles: Array) -> void:
	room_roles = _roles
	if ambassador_sprite and Card.CARD_TYPE.AMBASSADOR in room_roles:
		character_sprite_node.texture = ambassador_sprite
	if inquisitor_sprite and Card.CARD_TYPE.INQUISITOR in room_roles:
		character_sprite_node.texture = inquisitor_sprite


func update_players() -> void:
	AppManager.multiplayer_data["players_usernames"] = players_usernames
	player_count = players_container.get_child_count()
	clear_players_view()
	
	var index: int = 0
	for player_name in players_usernames:
		if players_container.get_child_count() >= MAX_PLAYER:
			waiting_players_node.hide()
		else:
			waiting_players_node.show()
		
		var player_node_to_add = player_item_scene.instance()
		players_container.add_child(player_node_to_add)
		player_node_to_add.get_node("MarginContainer/Label").text = player_name
		player_node_to_add.get_node("MarginContainer/Label").modulate = AppManager.players_colors[index]
		players_container.move_child(waiting_players_node, players_container.get_child_count())
		
		index += 1


func set_room_name(name: String) -> void:
	room_name = name
	update_page_title()


func set_room_id(id: int) -> void:
	room_id = id
	update_page_title()


func update_page_title() -> void:
	page_title.text = "%s | %d" % [room_name, room_id]


func clear_page() -> void:
	clear_chat()
	clear_players()
	clear_room_var()


func clear_chat() -> void:
	chat_text.text = ""
	chat_text.bbcode_text = ""


func clear_players() -> void:
	players_usernames = []
	player_count = 0
	player_username = "Username"
	player_id = 0
	clear_players_view()


func clear_players_view() -> void:
	var child_count: int = players_container.get_child_count()
	var index: int = 1
	
	for player_item in players_container.get_children():
		# Don't free 'WaitingPlayers' node
		if index != child_count:
			player_item.free()
		index += 1


func clear_room_var() -> void:
	room_id = 0
	room_name = "Room"
	room_roles = []


func display_welcome_msg() -> void:
	if chat_text.bbcode_text == "":
		chat_text.bbcode_text = "[color=#777777]Welcome to %s.[/color]" % [room_name]


func set_player_id(id: int) -> void:
	if id < 1:
		id = 1
	player_id = id
	AppManager.multiplayer_data["player_id"] = id
	player_color = AppManager.players_colors[player_id - 1]
	
	if player_id == 1:
		set_host_view()
	else:
		set_guest_view()


func set_player_username(username: String) -> void:
	player_username = username
	AppManager.multiplayer_data["username"] = username


func set_player_count(_player_count: int) -> void:
	player_count = _player_count
	AppManager.multiplayer_data["player_count"] = player_count


func set_host_view() -> void:
	start_label.text = "Start"
	start_btn.get_node("Icon").show()
	start_btn.disabled = false


func set_guest_view() -> void:
	start_label.text = "Waiting for Host"
	start_btn.get_node("Icon").hide()
	start_btn.disabled = true


################################################################################
# Network link methods
func _on_start_game(_player_count) -> void:
	if _player_count:
		player_count = _player_count
		AppManager.is_singleplayer = false
		AppManager.multiplayer_data["player_count"] = _player_count
		if game_scene:
			Loader.load_scene(game_scene)


func _on_player_connected(usernames: Array) -> void:
	if usernames:
		players_usernames = usernames
		update_players()
