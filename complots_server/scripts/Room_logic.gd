extends Node


var _room_table: Dictionary = {}
var _room_index: int = 0
var _network_ref : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	_network_ref = get_node("/root/Network")

func add_player(player_id,room_id) -> bool:
	if room_id in _room_table:
		if _room_table[room_id]["active_players"] < 8 and not _room_table[room_id]["running"]:
			_room_table[room_id]["active_players"] += 1
			_room_table[room_id]["players_id"].append(player_id)
			print(str(player_id) + " connected to room "+ str(room_id))
			return true
		else :
			return false
	else:
		return false

func remove_player(player_id,room_id) -> void:
	_room_table[room_id]["active_players"] -= 1
	print(str(player_id) + " disconnected from room "+str(room_id))
	#Disconnection of the player from server
	if _room_table[room_id]['running'] :
		_room_table[room_id]["remote"][player_id]._disconnect()

	if _room_table[room_id]["active_players"] == 0:
		end_room(room_id)
		return
	if _room_table[room_id]["id_creator"] == player_id:
		_room_table[room_id]["id_creator"] = _room_table[room_id]["players_id"][1]
	_room_table[room_id]["players_id"].erase(player_id)

func create_room(creator_id,room_name,roles=Board.DEFAULT_ROLES) -> int:
	print("room created " + str(_room_index))
	_room_table[_room_index] = {"active_players": 0,
			"name": room_name,
			"id_creator": creator_id,
			"players_id": [],
			"roles": roles,
			"running": false}
	_room_index += 1
	return _room_index-1

func start_room(room_id) -> void:
	#initialise les timers
	_room_table[room_id]['action_timer'] = Timer.new()
	_room_table[room_id]['bluff_timer'] = Timer.new()
	#ajout des timer a l'arborescence
	add_child(_room_table[room_id]['action_timer'])
	add_child(_room_table[room_id]['bluff_timer'])
	#initialisation de la board
	_room_table[room_id]['board'] = Board.new(
			 _room_table[room_id]['active_players'],
			_room_table[room_id]["roles"],
			_room_table[room_id]['action_timer'],
			_room_table[room_id]['bluff_timer']
	)
	#logique pour chaque joueurs
	_room_table[room_id]["players"] = {}
	_room_table[room_id]["remote"] = {}
	var count = 1
	for _id_usr in _room_table[room_id]['players_id']:
		#Player.new(id,username,color,roles)
		#initialisation player
		_room_table[room_id]["players"][_id_usr] = Player.new(_id_usr,
#				_id_room_table[_id_usr].username
				_network_ref.get_user_data(_id_usr)["username"],
				"#ffffff",
				_room_table[room_id]["roles"])
		#initialisation remote_player
		_room_table[room_id]["remote"][_id_usr] = Remote_player.new(_network_ref,
				room_id, # id room
				_id_usr, #id du joueur
				_network_ref.get_user_data(_id_usr)["username"],
				count
				)
		#Connection player - remote_player
		_room_table[room_id]["players"][_id_usr].connect_signals(
				_room_table[room_id]["remote"][_id_usr])
		#connection board - player
		_room_table[room_id]['board'].add_player(
				_room_table[room_id]["players"][_id_usr])
		#Connexion board - remote
		_room_table[room_id]['board'].connect("update_history",
				_room_table[room_id]["remote"][_id_usr],
				"_on_update_history")
		_room_table[room_id]['board'].connect("game_over",
				_room_table[room_id]["remote"][_id_usr],
				"_on_game_over")
		_room_table[room_id]['board'].connect("begin_turn",
				_room_table[room_id]["remote"][_id_usr],
				"_on_begin_turn")
		_room_table[room_id]['board'].connect("start_reaction",
				_room_table[room_id]["remote"][_id_usr],
				"_on_start_reaction")
		count +=1
	#lancement de la room
	_room_table[room_id]['running'] = true
	print("lancement room" + str(room_id) + " " + str(_room_table[room_id]['active_players']) + " joueurs")

	var launch = get_tree().create_timer(3.0)
	yield(launch,"timeout")

	_room_table[room_id]['board'].run()

func end_room(_room_id) -> void:
#	if _room_table[_room_id]["running"]:
#		_room_table[_room_id]["board"].queue_free()
#		for i in _room_table[_room_id]["remote"]:
#			_room_table[_room_id]["remote"][i].queue_free()
#			_room_table[_room_id]["player"][i].queue_free()
	var _s = _room_table.erase(_room_id)
func send_signal(user_id,room_id,data) -> void:
	if user_id in _room_table[room_id]["players_id"]:
		_room_table[room_id]["remote"][user_id].call(data["signal"],data)

func get_list() -> Dictionary:
	var data: Dictionary = {}
	for i in _room_table:
		if not _room_table[i]['running']:
			data[i] = {}
			data[i]["name"] = _room_table[i].name
			data[i]["count"] = _room_table[i].active_players
			data[i]["creator"] = _network_ref.get_user_data(
					_room_table[i]["id_creator"])["username"]
	return data

func get_players(room_id):
	if room_id in _room_table:
		return _room_table[room_id]["players_id"]
	else:
		return []
func get_creator(room_id):
	if room_id in _room_table:
		return _room_table[room_id]["id_creator"]
	else :
		return -1

func get_count(room_id):
	if room_id in _room_table:
		return _room_table[room_id]["active_players"]
	else :
		return -1

func get_room_name(room_id):
	if room_id in _room_table:
		return _room_table[room_id]["name"]
	else :
		return ""


func get_roles(room_id):
	if room_id in _room_table:
		return _room_table[room_id]["roles"]
	else :
		return []
