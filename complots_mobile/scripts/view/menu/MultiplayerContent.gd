extends VBoxContainer

signal connected_lobby()
signal connected_game(success)
signal back(previous_content, node_self)
onready var back_btn: Button = $PageTitle/Button
var previous_content = null

onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var no_room_label: Label = $Grid/Top/LeftColumn/RoomList/Content/Content/Background/MarginContainer/NoRoom
onready var create_room_btn: Button = $Grid/Bottom/Create/Button
onready var connect_btn: Button = $Grid/Bottom/Connect/Button
onready var refresh_btn: Button = $Grid/Top/LeftColumn/RoomList/Content/Header/Right/RefreshButton
onready var scroll_container: Node = $Grid/Top/LeftColumn/RoomList/Content/Content/Background/MarginContainer/ScrollContainer
onready var room_list_container: Node = $Grid/Top/LeftColumn/RoomList/Content/Content/Background/MarginContainer/ScrollContainer/RoomList
onready var search_field: LineEdit = $Grid/Top/LeftColumn/RoomList/Content/Header/Right/Search
onready var search_button: Button = $Grid/Top/LeftColumn/RoomList/Content/Header/Right/Search/SearchButton
onready var room_counter_label: Label = $Grid/Top/LeftColumn/RoomList/Content/Header/Right/RoomCounter
var login_register = null
var room_content = null
var room_settings = null

var room_item_scene = preload("res://scenes/menu/items/RoomItemList.tscn")
var selected_room_id: int = -1
var room_total_count: int = 0
var room_search_count: int = 0
var connected_room_info: Dictionary = {}

var _ret # To Stop Warnings


func _ready():
	_ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	_ret = back_btn.connect("pressed", self, "_on_Back_pressed")
	_ret = create_room_btn.connect("pressed", self, "_on_CreateRoom_pressed")
	_ret = connect_btn.connect("pressed", self, "_on_Connect_pressed")
	_ret = connect_btn.connect("mouse_entered", self, "_on_Connect_hover", [true])
	_ret = connect_btn.connect("mouse_exited", self, "_on_Connect_hover", [false])
	_ret = search_field.connect("text_changed", self, "_on_Search")
	_ret = search_button.connect("pressed", self, "_on_Search_Btn_pressed")
	_ret = refresh_btn.connect("pressed", self, "_on_Refresh_pressed")
	_ret = Network.connect("connected", self, "_on_Network_connected")
	
	Network.connect_menu(self)
	
	_on_window_resize()
	
	room_counter_label.hide()
	if room_settings:
		room_settings.hide()
		room_settings.set_process(false)


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
	connected_room_info = {}
	deselect_room()
	set_process(true)
	animation_player.play("show")
	
	_on_window_resize()
	
	fetch_room_list()
	
	if login_register:
		login_register.hide()
		login_register.set_process(true)
	
	if Network.connected and !Network.logged_in:
		yield(animation_player, "animation_finished")
		if login_register:
			if AppManager.user_data["login"]["username"] != "":
				login_register.login_username.text = AppManager.user_data["login"]["username"]
				login_register.login_password.grab_focus()
			else:
				login_register.login_username.grab_focus()
			login_register.show()
			login_register.set_process(false)


func fetch_room_list() -> void:
	Network.get_games_list()
	no_room_label.text = Localization.get("menu.connection_failed")


func _on_Network_connected() -> void:
	if visible:
		fetch_room_list()


func deselect_room() -> void:
	selected_room_id = -1


func _on_Back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	emit_signal("back", previous_content, self)


func _on_Refresh_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	refresh_btn.get_node("AnimationPlayer").play("pressed")
	fetch_room_list()


func _on_CreateRoom_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	if Network.connected:
		prompt_room_settings()


func prompt_room_settings() -> void:
	if room_settings:
		room_settings.show()
		room_settings.set_process(true)


func _on_create_room_validated(card_choice: int, room_name: String) -> void:
	if room_settings:
		room_settings.hide()
		room_settings.set_process(false)
	if Network.connected:
		var roles = [1, 2, 3, 4]
		roles.append(card_choice)
		Network.create_game(room_name, roles)
		var connection_success = yield(self, "connected_game")
		connect_game(connection_success)


func _on_Connect_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	if selected_room_id == -1 or !room_content:
		return
	
	if Network.connected:
		Network.join_game(selected_room_id)
		var connection_success = yield(self, "connected_game")
		connect_game(connection_success)


func _on_Connect_hover(is_hover: bool) -> void:
	if is_hover:
		connect_btn.get_parent().modulate = Color(0.6, 0.6, 0.6)
	else:
		connect_btn.get_parent().modulate = Color(1, 1, 1)


func connect_game(connection_success: bool) -> void:
	if connection_success:
		room_content.set_room_data(
			connected_room_info["room_id"], 
			connected_room_info["player_id"],
			connected_room_info["room_name"],
			connected_room_info["players_usernames"],
			connected_room_info["roles"])
		emit_signal("connected_lobby")
	else:
		# TODO: Display Error Message
		pass


func update_room_list(data: Dictionary) -> void:
	var selected_room_valid: bool = false
	var vertical_scroll: int = 0
	var room_item_height: int = 100 + 10 # item height + padding between items
	var index: int = 0
	
	clear_room_items()
	no_room_label.text = Localization.get("menu.no_room")
	if data == null:
		return
	
	for id in data:
		add_room(id, data[id]["name"], data[id]["creator"] if data[id]["creator"] else "", data[id]["count"])
		if id == selected_room_id:
			selected_room_valid = true
			vertical_scroll = int((index - 1.5) * room_item_height)
		index += 1
	
	if !selected_room_valid:
		selected_room_id = -1
	
	room_total_count = index
	room_search_count = index
	scroll_container.scroll_vertical = vertical_scroll
	update_selected_visual()


func add_room(room_id: int, room_name: String, room_creator: String, player_count: int) -> void:
	if no_room_label.visible:
		no_room_label.hide()
	var room_to_add = room_item_scene.instance()
	room_list_container.add_child(room_to_add)
	room_to_add.connect_pressed(self, "_on_room_pressed")
	room_to_add.set_room_id(room_id)
	room_to_add.set_room_name(room_name)
	room_to_add.set_room_creator(room_creator)
	room_to_add.set_player_count(player_count)


func _on_room_pressed(calling_node: Node) -> void:
	selected_room_id = calling_node.id
	update_selected_visual()


func update_selected_visual() -> void:
	for room_item in room_list_container.get_children():
		room_item.set_pressed(room_item.id == selected_room_id)


func clear_room_items() -> void:
	for room_item in room_list_container.get_children():
		room_item.queue_free()
	no_room_label.show()


func _on_Search_Btn_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	search_field.grab_focus()
	_on_Search(search_field.text)


func _on_Search(search_text: String) -> void:
	filter_rooms(search_text)


func filter_rooms(pattern: String) -> void:
	var empty: bool = true
	room_search_count = 0
	
	for room_item in room_list_container.get_children():
		if pattern == "" or pattern in room_item.get_room_text():
			room_item.show()
			empty = false
			room_search_count += 1
		else:
			room_item.hide()
	
	if pattern != "":
		room_counter_label.text = "%d/%d" % [room_search_count, room_total_count]
		room_counter_label.show()
	else:
		room_counter_label.text = ""
		room_counter_label.hide()
	
	no_room_label.visible = empty

################################################################################
# Network link methods
func _on_connect_game(room_id: int, player_id: int, room_name: String, usernames: Array, roles: Array) -> void:
	connected_room_info = {
		"room_id": room_id,
		"player_id": player_id,
		"room_name": room_name,
		"players_usernames": usernames,
		"roles": roles,
	}
	emit_signal("connected_game", true)


func _on_quit_game() -> void:
	emit_signal("connected_game", false)


func _on_games_list(data: Dictionary) -> void:
	update_room_list(data)


func _on_update_log(_result, _username) -> void:
	pass
