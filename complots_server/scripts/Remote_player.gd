extends Node

class_name Remote_player

var _id_user: int
var _id_room: int
var _username: String
var _ig_id: int
var _ref_ntw: Node
var _serial = load("res://scripts/Serializer.gd")
var _is_connected: bool

signal choose_action(action_type, targets_id, card_type)
signal reaction(action_type, calling_action, card_type)
signal choose_cards(cards)
signal choose_options(option)
signal hand_updated()

func _ready():
	pass

func _init(network, idroom, id, username, ig_id) -> void:
	_ref_ntw = network
	_id_user = id
	_username = username
	_id_room = idroom
	_ig_id = ig_id
	_is_connected = true
###############################
func _on_play_turn(player: Player_Base, roles: Array, players_data: Dictionary) -> void:
	# code
	var args: Dictionary = {}
	args["signal"] = "_play_turn"
	args["player"] = _serial.player_to_dic(player)
	args["roles"] = roles
	args["players_data"] = players_data
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _choose_action(data: Dictionary) -> void:
	var action_type = data["action_type"]
	var card_type = data["card_type"]
	var targets = data["targets"] #int array
	emit_signal("choose_action",action_type,card_type,targets)
###############################
func _on_make_reaction(calling_action: Action, roles: Array, player: Player_Base) -> void:
	# code
	var args: Dictionary = {}
	args["signal"] = "_make_reaction"
	args["calling_action"] = _serial.action_to_dic(calling_action)
	args["roles"] = roles
	args["player"] = _serial.player_to_dic(player)
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

#	print("signal " + args["signal"])
func _reaction(data: Dictionary)-> void:
	var action_type = data["action_type"]
	var calling_action = _serial.dic_to_action(data["calling_action"])
	var card_type = data["card_type"]
	emit_signal("reaction",action_type,calling_action,card_type)
###############################

func _on_choose_cards(cards: Array, qty: int, text: String, select_type: int) -> void:
	# code
	var args: Dictionary = {}
	args["signal"] = "_choose_cards"
	args["cards"] = {}
	print(cards)
	for i in range(cards.size()):
		args["cards"][i] = _serial.card_to_dic(cards[i])
	args["qty"] = qty
	args["text"] = text
	args["select_type"] = select_type
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _choose_cards(data: Dictionary) -> void:
	var select = data["select"]
	#	var select = data["select"] #array of ?
	emit_signal("choose_cards",select)
###############################
func _on_choose_options(options : Array, text : String, card_type: int) -> void:
	# code
	var args: Dictionary = {}
	args["signal"] = "_choose_options"
	args["options"] = options
	args["text"] = text
	args["card_type"] = card_type
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _choose_options(data: Dictionary) -> void:
	var options = data["options"]
	emit_signal("choose_options",options)

################################################################################
# INIT VIEW
################################################################################
func _on_init_player(player: Player_Base) -> void:
	var args: Dictionary = {}
	args["signal"] = "_init_player"
	args["id"] = _ig_id
	args["player"] = _serial.player_to_dic(player)
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

################################################################################
# UPDATE HAND VIEW
################################################################################
func _on_add_card(card: Card, _player_hand: Array = []) -> void:
	var args: Dictionary = {}
	args["signal"] = "_add_card"
	args["card"] = _serial.card_to_dic(card)
	args["id"] = _ig_id
	if _is_connected == true :
		_ref_ntw.rpc_room(_id_user,"call_signal",args)
	emit_signal("hand_updated")


func _on_remove_card(card_id: int, _player_hand: Array = []) -> void:
	var args: Dictionary = {}
	args["signal"] = "_remove_card"
	args["card_id"] = card_id
	args["id"] = _ig_id
	if _is_connected == true :
		_ref_ntw.rpc_room(_id_user,"call_signal",args)
	emit_signal("hand_updated")


func _on_kill_card(card_id: int, card_type: int, is_alive: bool = true, _player_hand: Array = []) -> void:
	var args: Dictionary = {}
	args["signal"] = "_kill_card"
	args["card_id"] = card_id
	args["card_type"] = card_type
	args["is_alive"] = is_alive
	args["id"] = _ig_id
	if _is_connected == true :
		_ref_ntw.rpc_room(_id_user,"call_signal",args)
	emit_signal("hand_updated")

###############################################################################
# CASUAL UPDATE VIEW
###############################################################################

func _on_change_balance(balance: int) -> void:
	var args: Dictionary = {}
	args["signal"] = "_change_balance"
	args["balance"] = balance
	args["id"] = _ig_id
	if _is_connected == true :
		_ref_ntw.rpc_room(_id_user,"call_signal",args)

func _on_update_history(msg: String, action: Action) -> void:
	var args: Dictionary = {}
	args["signal"] = "_update_history"
	args["msg"] = msg
	args["action"] = _serial.action_to_dic(action)
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _on_start_reaction(_action: Action, _time: int) -> void:
	var args: Dictionary = {}
	args["signal"] = "_start_reaction"
	args["action"] = _serial.action_to_dic(_action)
	args["time"] = _time
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _on_player_action(_action: Action) -> void:
	print("player action called")
	var args: Dictionary = {}
	args["signal"] = "_player_action"
	args["action"] = _serial.action_to_dic(_action)
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _on_end_reaction() -> void:
	var args: Dictionary = {}
	args["signal"] = "_end_reaction"
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _on_stop_reaction() -> void:
	var args: Dictionary = {}
	args["signal"] = "_stop_reaction"
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _on_game_over(player: Player_Base) -> void:
	var args: Dictionary = {}
	args["signal"] = "_game_over"
	args["player"] = _serial.player_to_dic(player)
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _on_end_turn() -> void:
	var args: Dictionary = {}
	args["signal"] = "_end_turn"
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _on_begin_turn(_active_player_id: int) -> void:
	var args: Dictionary = {}
	args["signal"] = "_begin_turn"
	args["active_player"] = _active_player_id
	if _is_connected == true :
		_ref_ntw.rpc_id(_id_user,"call_signal",args)

func _disconnect():
	_is_connected = false

func _connect():
	_is_connected = true
