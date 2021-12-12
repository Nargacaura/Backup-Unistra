extends Node

const PORT: int = 6666
const IP: String = "51.210.47.29"
#make id start at 1+id_decal instead of 1
const id_decal = -1
var _err: int
var _serial = load("res://scripts/Serializer.gd")


#player is connected to a game
#room : the id of the room/lobby
#id : the player id in the game
#name : server name
#roles : roles of the game
signal connect_game(room,id,name,roles)
#player has quit the game
signal quit_game()
#the game begin
#count : number of player for this game
signal start_game(count)
#the game is finished
signal end_game()
#result of a log tentative
#result : a boolean that indicate the result
#username : the username of the player, by default the username is guest_[id]
signal update_log(result,username)
#update the current chat
#username : the sender name
#msg : the message sent
signal update_chat(username,msg)
signal update_history(msg)
#player has joined the game
#user : the username
signal player_connected(users)

#signal with id, global information
signal add_card(id,card)# /!\ if id != this player id : card = NULL
signal remove_card(id,card_id)
signal change_balance(id,balance)
signal kill_card(id,card_id,card_type,is_alive)
#core signal
signal begin_turn(active_player_id)
signal play_turn(player, roles, players_data)
signal make_reaction(calling_action,roles)
signal start_reaction(calling_action,roles)
signal choose_cards(cards,qty,text)
signal choose_options(options,text)
signal init_player(id,player)
signal player_action(_action)
signal end_reaction()
signal stop_reaction()
signal end_turn()
signal games_list(data)

func _ready():
	_err = get_tree().connect("connected_to_server", self, "_connected_ok")
	_err = get_tree().connect("connection_failed", self, "_connected_fail")
	_err = get_tree().connect("server_disconnected", self, "_server_disconnected")

	var _client_peer = NetworkedMultiplayerENet.new()
	_err = _client_peer.create_client(IP, PORT)
	if _err != OK :
		print("erreur")
	get_tree().set_network_peer(_client_peer)



######################## LOBBY FUNCTIONS ################################
#ask the server to create a game
#ask to log
func create_game(name,roles):
	rpc_id(1,"create_game",name,roles)
#ask the server to join a game
#answer : connect_game
func join_game(game_id):
	rpc_id(1,"join_game",game_id)
#get the list of current game, receive a dictionary
#answer : games_list
func get_games_list():
	rpc_id(1,"get_games_list")
#ask to start a game, only the creator of the game can launch the game
func start_game():
	rpc_id(1,"start_game")
#quite the current game
func quit_game():
	rpc_id(1,"leave_game")
#ask to log
func connect_login(id,mdp):
	rpc_id(1,"connect_login",id,mdp)
#ask to create an account
# answer : update_log
func create_login(id,mdp,username):
	rpc_id(1,"create_login",id,mdp,username)
#update the current chat
func update_chat(username,msg):
	var data = {"signal":"_update_chat",
			"username":username,
			"msg":msg
			}
	rpc_id(1,"update_chat",data)

######################### REMOTE FUNCTIONS ###############################
#receive the result of logging
remote func receive_login_result(result,username) -> void:
	emit_signal("update_log",result,username)

remote func receive_games_list(_data: Dictionary):
	emit_signal("games_list",_data)

remote func call_signal(data: Dictionary)-> void:
	#print("signal :" + data["signal"])
	self.call(data["signal"],data)

remote func connect_result(result,room,id,name,users,roles) -> void:
	if result :
		global.players = users
		global.roles = roles
		print(roles)
		print("Joined the server successfully.")
		emit_signal("connect_game",room,id+id_decal,name,roles)
		print("connected "+str(room) + " " + name)
	else:
		emit_signal("quit_game")
		print("Failed to join the server.")

remote func remote_start_game(count):
	print("start game")
	emit_signal("start_game",count)

######################### connect signal ###########################


func connect_menu(view):
	var _s
	_s = self.connect("connect_game", view, "_on_connect_game")
	_s = self.connect("games_list", view, "_on_games_list")
	_s = self.connect("update_log", view, "_on_update_log")

func connect_lobby(view):
	var _s = self.connect("start_game", view, "_on_start_game")
	_s = self.connect("player_connected", view, "_on_player_connected")
	_s = self.connect("update_chat", view, "_on_update_chat")


func connect_signals(view):
	var _s
	_s = self.connect("quit_game", view, "_on_quit_game")

	_s = view.connect("choose_action", self, "_on_choose_action")
	_s = view.connect("choose_cards", self, "_on_choose_cards")
	_s = view.connect("choose_options", self, "_on_choose_options")
	_s = view.connect("reaction", self, "_on_reaction")

	_s = self.connect("update_chat", view, "_on_update_chat")
	_s = self.connect("update_history", view, "_on_update_history")
	_s = self.connect("begin_turn", view, "_on_begin_turn")
	_s = self.connect("play_turn", view, "_on_play_turn")
	_s = self.connect("choose_cards", view, "_on_choose_cards")
	_s = self.connect("choose_options", view, "_on_choose_options")
	_s = self.connect("make_reaction", view, "_on_make_reaction")
	_s = self.connect("kill_card", view, "_on_kill_card")
	_s = self.connect("init_player", view, "_on_init_player")
	_s = self.connect("change_balance", view, "_on_change_balance")
	_s = self.connect("add_card", view, "_on_add_card")
	_s = self.connect("remove_card", view, "_on_remove_card")
	_s = self.connect("end_reaction", view, "_on_end_reaction")
	_s = self.connect("end_turn", view, "_on_end_turn")
	_s = self.connect("player_action", view, "_on_player_action")
	_s = self.connect("start_reaction", view, "_on_start_reaction")
	_s = self.connect("stop_reaction", view, "_on_stop_reaction")
	_s = self.connect("end_game", view, "_on_end_game")

####################### Prototype #######################################
#func _on_choose_cards(cards: Array, qty: int, text: String):
#func _on_choose_option(options : Array, text : String):
#func _on_make_reaction(calling_action: Action, roles: Array):
#func _on_change_balance(id,balance: int):
#func _on_player_action(action: Action):
#func _on_play_turn(player: Player_Base, roles: Array, players_data: Dictionary):
#func _on_stop_reaction():
#func _on_end_turn():
#func _on_end_reaction():
#func _on_remove_card(id,card_id: int):
#func _on_add_card(id,card: Card):
#func _on_init_player(id,player: Player_Base):
#func _on_kill_card(id,card_id: int, card_type: int, is_alive: bool = true):

######################### SIGNAL FUNCTIONS ###############################

func _connected_ok() -> void:
	print("success_connect")

func _connected_fail():
	print("fail_connect")

func _server_disconnected():
	print("server_disconnected")

func _on_choose_action(action_type: int = Action.ACTION_TYPE.INCOME,
		card_type: int = 0,
		targets_id: Array = [0]) -> void:
	var data: Dictionary = {}
	data["signal"] = "_choose_action"
	data["action_type"] = action_type
	data["card_type"] = card_type
	data["targets"] = targets_id
	rpc_id(1,"call_signal",data)

func _on_choose_cards(cards: Array) -> void:
	var data: Dictionary = {}
	data["signal"] ="_choose_cards"
	data["select"] = cards
	print(data)
	rpc_id(1,"call_signal",data)

func _on_choose_options(options: Array) -> void:
	var data: Dictionary = {}
	data["signal"] = "_choose_options"
	data["options"] = options
	rpc_id(1,"call_signal",data)

func _on_reaction(action_type: int, calling_action: Action, card_type: int) -> void:
	var data: Dictionary = {}
	data["signal"] = "_reaction"
	data["action_type"] = action_type
	data["calling_action"] = _serial.action_to_dic(calling_action)
	data["card_type"] = card_type
	rpc_id(1,"call_signal",data)

#############################################################################

func _start_reaction(data):
	var action = _serial.dic_to_action(data["action"])
	var time = data["time"]
	emit_signal("start_reaction",action,time)

func _player_connected(data):
	var users = data["players"]
	emit_signal("player_connected",users)

func _update_chat(data: Dictionary)-> void:
	var username = data["username"]
	var msg = data["msg"]
	emit_signal("update_chat",username,msg)

func _update_history(data: Dictionary)-> void:
	var msg = data["msg"]
	emit_signal("update_history",msg)

func _add_card(data: Dictionary)-> void:
	var card = _serial.dic_to_card(data["card"])
	var id = data['id'] + id_decal
	emit_signal("add_card",id,card)

func _remove_card(data: Dictionary) -> void:
	var card_id = data["card_id"]
	var id = data['id'] + id_decal
	emit_signal("remove_card",id,card_id)

func _kill_card(data: Dictionary) -> void:
	var card_id = data["card_id"]
	var card_type = data["card_type"]
	var is_alive = data["is_alive"]
	var id = data['id'] + id_decal
	emit_signal("kill_card",id,card_id,card_type,is_alive)

func _change_balance(data: Dictionary) -> void:
	var balance = data["balance"]
	var id = data['id'] + id_decal
	emit_signal("change_balance",id,balance)

func _init_player(data: Dictionary) -> void:
	var player = _serial.dic_to_player(data["player"])
	var id = data["id"] + id_decal
	emit_signal("init_player",id,player)

func _play_turn(data: Dictionary) -> void:
	var player = _serial.dic_to_player(data["player"])
	var roles = data["roles"]
	var players_data = data["players_data"]
	emit_signal("play_turn",player,roles,players_data)

func _make_reaction(data: Dictionary) -> void:
	var calling_action = _serial.dic_to_action(data["calling_action"])
	var roles = data["roles"]
	emit_signal("make_reaction",calling_action,roles)

func _choose_cards(data: Dictionary) -> void:
	var cards = []
	for i in data["cards"]:
		cards.append(_serial.dic_to_card(data["cards"][i]))
	var qty = data["qty"]
	var text = data["text"]
	emit_signal("choose_cards",cards,qty,text)

func _choose_options(data: Dictionary)-> void:
	var options = data["options"]
	var text = data["text"]
	emit_signal("choose_options",options,text)

func _player_action(data: Dictionary) -> void:
	var action = _serial.dic_to_action(data["action"])
	emit_signal("player_action",action)

func _end_reaction(_data: Dictionary) -> void:
	emit_signal("end_reaction")

func _stop_reaction(_data: Dictionary)-> void:
	emit_signal("stop_reaction")

func _game_over(data: Dictionary)-> void:
	var player = _serial.dic_to_player(data["player"])
	emit_signal("end_game", player)

func _begin_turn(data: Dictionary)-> void:
	var active_player_id: int = data["active_player"]
	emit_signal("begin_turn", active_player_id)

func _end_turn(_data: Dictionary)-> void:
	emit_signal("end_turn")
