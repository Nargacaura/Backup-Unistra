extends Node

const PORT: int = 6666
const MAX_PLAYERS: int = 200
var _server: NetworkedMultiplayerENet
var _err: int
var _id_table: Dictionary
var _rooms: Node
var _db : Node
var _serial = load("res://scripts/Serializer.gd")
func _ready():
	_err = get_tree().connect("network_peer_connected", self, "_on_client_connected")
	_err = get_tree().connect("network_peer_disconnected", self, "_on_client_disconnected")
	_server = NetworkedMultiplayerENet.new()
	_err = _server.create_server(PORT, MAX_PLAYERS)
	if _err != OK:
		get_tree().quit()
	get_tree().set_network_peer(_server)
	_rooms = get_node("/root/Main/Room_logic")
	_db = get_node("/root/Database")
	_id_table = {}



func _on_client_connected(_id):
	_id_table[_id] = {}
	_id_table[_id]["username"] = "guest_" + str(_id)
	_id_table[_id]["room"] = -1
	rpc_id(_id,"receive_login_result",false,_id_table[_id]["username"])
	print(str(_id) + " connected")

func _on_client_disconnected(_id):
	print(str(_id) + " disconnected")
	if _id_table[_id].room != -1 :
		remove_player(_id)
	_err = _id_table.erase(_id)

func get_user_data(_id):
	return _id_table[_id]

func add_player(usr_id,room_id):
	if _rooms.add_player(usr_id,room_id):
		_id_table[usr_id].room = room_id
		return true
	else:
		return false

func remove_player(user_id):
	var room_id = _id_table[user_id]["room"]
	
	var users = []
	var lst = _rooms.get_players(room_id)
	for i in lst.size():
		if lst[i] != user_id:
			users.append(_id_table[lst[i]]["username"])
	rpc_room(user_id,"call_signal",{"signal":"_player_connected","players":users})
	
	_rooms.remove_player(user_id,room_id)
	_id_table[user_id].room = -1


func send_games_list(usr_id):
	var data: Dictionary = _rooms.get_list()
	rpc_id(usr_id,"receive_games_list",data)

func rpc_room(sender_id,fun,data):
	if sender_id in _id_table:
		var room_id = _id_table[sender_id]['room']
		rpc_id(sender_id,fun,data)
		if data["signal"] == "_add_card":
			var card = Card.new()
			card._type = Card.CARD_TYPE.HIDDEN
			card._counters = []
			data["card"] = _serial.card_to_dic(card)
		for id in _rooms.get_players(room_id):
			if id != sender_id:
				rpc_id(id,fun,data)
###################### remote function ####################

remote func update_chat(data: Dictionary):
	var user_id: int = get_tree().get_rpc_sender_id()
	rpc_room(user_id,"call_signal",data)

remote func connect_login(id,mdp):
	var user_id: int = get_tree().get_rpc_sender_id()
	var result = _db.check_user(id,mdp.sha256_text())
	if result.size():
		_id_table[user_id]["username"] = result[0]["username"]
		rpc_id(user_id,"receive_login_result",true,result[0]["username"])
	else:
		rpc_id(user_id,"receive_login_result",false,_id_table[user_id]["username"])

remote func create_login(id : String,mdp: String,username: String):
	var user_id: int = get_tree().get_rpc_sender_id()
	var result = _db.insert_user(id,mdp.sha256_text(),username)
	if result:
		_id_table[user_id]["username"] = username
		rpc_id(user_id,"receive_login_result",result,username)
	else:
		rpc_id(user_id,"receive_login_result",result,_id_table[user_id]["username"])

remote func join_game(room_id):
	var user_id: int = get_tree().get_rpc_sender_id()
	var result = add_player(user_id,int(room_id))
	var room_name = _rooms.get_room_name(int(room_id))
	var id = -1
	var roles = _rooms.get_roles(int(room_id))
	var users = []
	if result :
		id = _rooms.get_players(room_id).size() 
	#notify all connected player that a new player has join the game
	if result:
		var lst = _rooms.get_players(room_id)
		for i in lst.size():
			users.append(_id_table[lst[i]]["username"])
		#send a list of all username to players
		rpc_room(user_id,"call_signal",{"signal":"_player_connected","players":users})
	rpc_id(user_id,"connect_result",result,room_id,id,room_name,users,roles)

remote func leave_game():
	var user_id: int = get_tree().get_rpc_sender_id()
	remove_player(user_id)
	rpc_id(user_id,"connect_result", false, -1, -1, "", [], [])

remote func get_games_list():
	var user_id: int = get_tree().get_rpc_sender_id()
	send_games_list(user_id)

remote func call_signal(data: Dictionary):
	var user_id: int = get_tree().get_rpc_sender_id()
	var room_id = _id_table[user_id].room
	_rooms.send_signal(user_id,room_id,data)

remote func start_game():
	var user_id: int = get_tree().get_rpc_sender_id()
	var room_id = _id_table[user_id]["room"]
	if user_id == _rooms.get_creator(room_id):
		if _rooms.get_count(room_id) >= 2:
			for id in _rooms.get_players(room_id):
				rpc_id(id,"remote_start_game",_rooms.get_count(room_id))
			_rooms.start_room(room_id)

remote func create_game(room_name,roles=Board.DEFAULT_ROLES):
	var user_id: int = get_tree().get_rpc_sender_id()
	var room_id = _rooms.create_room(user_id,room_name,roles)
	_err = add_player(user_id,room_id)
	rpc_id(user_id,"connect_result",true,room_id,1,room_name,[_id_table[user_id].username],roles)
	print(roles)
