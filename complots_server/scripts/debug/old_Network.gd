extends Node

const PORT := 6666
const MAX_PLAYERS := 200

var _id_room_table: Dictionary = {}
var _room_table: Dictionary = {} 
var _last_idroom: int = 0
var _err: int
var _db: Node

func _ready():
	_err = get_tree().connect("network_peer_connected", self, "_on_client_connected")
	_err = get_tree().connect("network_peer_disconnected", self, "_on_client_disconnected")
	var _server = NetworkedMultiplayerENet.new()
	_err = _server.create_server(PORT, MAX_PLAYERS)
	if _err != OK:
		get_tree().quit()
	get_tree().set_network_peer(_server)
	print("start serveur")
	
#	_db = get_node("/root/Database")
	
################################################################################
#                            COMMUNICATION FUNCTIONS                           #
################################################################################
# No variadic argument available, must use array (or dict) for multiple args
func rpc_room(idroom: int, fun: String, data: Dictionary = {}) -> void:
	if "active_player_id" in data:
		rpc_id(data["active_player_id"],fun,data["active_player_data"])
		for id in _room_table[idroom].players_id:
			if id != data["active_player_id"]:
				rpc_id(id, fun, data["other_players_data"])
	else:
		for id in _room_table[idroom].players_id:
			rpc_id(id, fun, data)

func rpc_room_id(id_client: int,fun: String,data: Dictionary = {}) -> void:
	if id_client in _id_room_table:
		rpc_id(id_client,fun,data)

func _send_rooms_list(_id: int) -> void:
	var _data: Dictionary = {}
	if _id in _id_room_table:
		for _key in _room_table:
			_data[_key] = {
				"name" : _room_table[_key]["name"] ,
				"creator" : _id_room_table[_room_table[_key]["id_creator"]]["username"],
				"active_players" : _room_table[_key]["active_players"],
				"running" : _room_table[_key]["running"]
			}
		rpc_id(_id,"receive_rooms_list",_data)



################################################################################
#                          REMOTE FUNCTIONS                                    #
################################################################################
#
#remote func ask_login(_username: String, _passwd: String) -> void:
#	var _id: int = get_tree().get_rpc_sender_id() 
#	var is_logged: int = _db.check_user(_username, _passwd)
#	rpc_id(_id, "receive_login_result", is_logged)


remote func ask_create_room(_roomname: String) -> void:
	var _id: int = get_tree().get_rpc_sender_id()
#	_init_room(_id, roomname)
# To continue

remote func ask_rooms_list() -> void:
	var _id: int = get_tree().get_rpc_sender_id()
	if _id in _id_room_table:
		_send_rooms_list(_id)
		
remote func ask_join(_idroom: int) -> void:
	var _id: int = get_tree().get_rpc_sender_id()
#	if idroom in _room_table:
#		_add_player(_id,idroom)
		
remote func call_signal(data: Dictionary) -> void:
	var id: int = get_tree().get_rpc_sender_id()
	if id in _id_room_table:
		var idroom: int = _id_room_table[id]["room"]
		if idroom in _room_table:
			_room_table[idroom]["remote"][id].call(data["signal"],data)
######################### SIGNAL FUNCTIONS ###############################

func _on_client_connected(id: int) -> void:
	print("user connected :"+str(id))
	_id_room_table[id] = {"room": -1}
#	if _last_idroom == 0:
#		_init_room(id,"test_room")
	_id_room_table[id]['username'] = "test_"+str(id)
#	_add_player(id,0)
#	get_node("/root/communication").rpc_id(id,"print_test","COMMUNICATION")
	
func _on_client_disconnected(id: int) -> void:
	print("user disconnected id : "+str(id) + " room :"+str(_id_room_table[id]["room"]))
	#if the player is in a room and disconnect
	#the room has -1 active players remaining
	if _id_room_table[id]["room"] != -1 :
		_room_table[_id_room_table[id]["room"]]["active_players"] -= 1
		_room_table[_id_room_table[id]["room"]].players_id.erase(id)
	#each connection has a unique id so we don't neet to keep useless key
	_err = _id_room_table.erase(id)
	if _err != OK:
		print("error erase client from table")

##################### temp func #######################


remote func add_client(username):
	var id: int = get_tree().get_rpc_sender_id()
	_id_room_table[id]["username"] = username
	print("client added, username "  +str(username) + " id "+ str(id))


func _on_start_room_pressed():
#	_start_room(0,Board.DEFAULT_ROLES)
	pass

#################################################################################
##                         LOGIC FUNCTIONS                                      #
#################################################################################
##initialization of a room
#func _init_room(id_creator,name: String) -> void:
#	_room_table[_last_idroom] = {"active_players": 0,
#			"name": name,
#			"id_creator":id_creator, 
#			"players_id": [],
#			"running": false}
#	_last_idroom += 1
#
##add user data to _id_room_table
#func connect_user(_id: int):
#	pass 

##Start a room, initialize player and run a board
#func _start_room(_id,_roles: Array = Board.DEFAULT_ROLES)->void :
#	#initialise les timers
#	_room_table[_id]['action_timer'] = Timer.new() 
#	_room_table[_id]['bluff_timer'] = Timer.new()
#	#ajout des timer a l'arborescence
#	add_child(_room_table[_id]['action_timer'])
#	add_child(_room_table[_id]['bluff_timer'])
#
#	var _pls_count: int = _room_table[_id]['active_players']
#	#initialisation de la board
#	_room_table[_id]['board'] = Board.new(
#			_pls_count,
#			_roles,
#			_room_table[_id]['action_timer'], 
#			_room_table[_id]['bluff_timer']
#	)
#	_room_table[_id]["players"] = {}
#	_room_table[_id]["remote"] = {}
#	for _id_usr in _room_table[_id]['players_id']:
#		#Player.new(id,username,color,roles)
#		#initialisation player
#		_room_table[_id]["players"][_id_usr] = Player.new(_id_usr,
#				_id_room_table[_id_usr].username, 
#				"#ffffff",
#				_roles)
#		#initialisation remote_player
#		_room_table[_id]["remote"][_id_usr] = Remote_player.new(self,
#				_id, # id room
#				_id_usr, #id du joueur
#				_id_room_table[_id_usr].username
#				)
#		#Connection player - remote_player
#		_room_table[_id]["players"][_id_usr].connect_signals(_room_table[_id]["remote"][_id_usr])
#		#connection board - player
#		_room_table[_id]['board'].add_player(_room_table[_id]["players"][_id_usr])
#	#lancement de la room
#	_room_table[_id]['running'] = true
#	_room_table[_id]['board'].run()
#
##add a player to a room
#func _add_player(player_id:int,idroom:int) -> int:
#	if idroom in _room_table:
#		if _room_table[idroom]["active_players"] < 8:
#			_id_room_table[player_id]["room"] = idroom
#			_room_table[idroom]["active_players"] += 1
#			_room_table[idroom].players_id.append(player_id)
#			print("connected")
#			return 0
#		else :
#			return -1
#	else:
#		return -1
