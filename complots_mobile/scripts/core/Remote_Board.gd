extends Board

class_name Remote_Board

signal choose_action(action_type, card_type, targets_id)
signal choose_cards(cards)
signal choose_options(options)
signal reaction(action_type, calling_action, card_type)

signal begin_timer(timer_node)

signal update_chat(message)

func _init(player_count: int = -1,
			roles: Array = DEFAULT_ROLES,
			action_timer: Timer = null,
			bluff_timer: Timer = null):
	var _s # Top with the warnings for surefire events
	_game_state = GAME_STATE.INITIALIZATION
	_player_count = player_count if player_count > 1 and player_count < 9 else -1
	_players = []
	_deck = []
	_roles = roles
	_validate_roles()
	_actions = []
	_active_player_id = 1
	_turn_count = 1
	_action_timer = action_timer
	if _action_timer != null:
		_action_timer.one_shot = true
		#_s = _action_timer.connect("timeout", self, "_on_action_timeout")
	_bluff_timer = bluff_timer
	if _bluff_timer != null:
		_bluff_timer.one_shot = true
		_s = _bluff_timer.connect("timeout", self, "_on_bluff_timeout")


func connect_network_view(player_view: Node) -> void:
	var _ret = player_view.connect("choose_action", self, "_choose_action")
	_ret = player_view.connect("choose_cards", self, "_choose_cards")
	_ret = player_view.connect("choose_options", self, "_choose_options")
	_ret = player_view.connect("reaction", self, "_reaction")


func add_player(player: Player_Base) -> int:
	# If already at max player capacity don't add an other one
	if _players.size() >= _player_count:
		return -1
	# Core signals
	var _s # Top with the warnings for surefire events
	player._id = _players.size() + 1
	_players.push_back(player)
	# Return player id
	return player._id


func _on_update_history(message: String, action: Action) -> void:
	emit_signal("update_history", message, action)


func _on_add_card(player_id: int, card: Card) -> void:
	_players[player_id - 1].add_card(card)
	emit_signal("update_player_view", _players[AppManager.player_game_id - 1])


func _on_remove_card(player_id: int, card_index: int) -> void:
	_players[player_id - 1].remove_card(card_index)
	emit_signal("update_player_view", _players[AppManager.player_game_id - 1])


func _on_kill_card(player_id: int, card_index: int, card_type: int, _is_player_alive: bool) -> void:
	_players[player_id - 1]._hand[card_index]._type = card_type
	_players[player_id - 1].kill_card(card_index)
	emit_signal("update_player_view", _players[AppManager.player_game_id - 1])


func _on_change_balance(player_id: int, balance: int) -> void:
	_players[player_id - 1].set_balance(balance)


func _on_init_player(_player_id: int, _player: Player_Base) -> void:
	_players[_player_id - 1].emit_signal("init_player", _player)


func _on_play_turn(player: Player_Base, roles: Array, players_data: Dictionary) -> void:
	start_timer(_action_timer, Action.ACTION_TIMEOUT)
	emit_signal("begin_timer", _action_timer)
	AppManager.multiplayer_data["player_view"]._players_data = players_data
	_players[player.get_id() - 1]._roles = roles
	_players[player.get_id() - 1].play_turn(players_data)


func _on_make_reaction(calling_action: Action, roles: Array, _player: Player_Base) -> void:
	start_timer(_bluff_timer, Action.ACTION_TIMEOUT)
	print("Func _on_make_reaction: Calling action ", calling_action._sender_id)
	_players[AppManager.player_game_id - 1]._roles = roles
	AppManager.multiplayer_data["player_view"]._calling_action = calling_action
	_players[AppManager.player_game_id - 1]._on_start_reaction(calling_action, 0)


func _on_start_reaction(_calling_action: Action, time: int) -> void:
	start_timer(_bluff_timer, time)
	emit_signal("begin_timer", _bluff_timer)


func _on_choose_cards(cards: Array, qty: int, text: String, select_type: int) -> void:
	_players[AppManager.player_game_id - 1].select_cards(cards, qty, text, select_type)


func _on_choose_options(options: Array, text: String, card_type: int) -> void:
	_players[AppManager.player_game_id - 1].branch_options(options, text, card_type)


func _on_player_action(action: Action) -> void:
	_players[AppManager.player_game_id - 1].emit_signal("player_action", action)


func _on_end_reaction() -> void:
	_players[AppManager.player_game_id - 1].emit_signal("end_reaction")


func _on_stop_reaction() -> void:
	_players[AppManager.player_game_id - 1].emit_signal("stop_reaction")


func _on_end_game(player: Player_Base) -> void:
	emit_signal("game_over", player)


func _on_begin_turn(active_player_id: int):
	emit_signal("begin_turn", active_player_id)


func _on_end_turn() -> void:
	emit_signal("end_turn")
	_players[AppManager.player_game_id - 1].emit_signal("end_turn")

################################################################################
# Responds to Server
func _choose_action(action_type: int = Action.ACTION_TYPE.INCOME, card_type: int = 0, targets_id: Array = [0]):
	emit_signal("choose_action", action_type, card_type, targets_id)


func _choose_cards(cards: Array):
	emit_signal("choose_cards", cards)


func _choose_options(options: Array):
	emit_signal("choose_options", options)


func _reaction(action_type: int, calling_action: Action, card_type: int):
	print("Func _reaction: Calling action ", calling_action._sender_id)
	emit_signal("reaction", action_type, calling_action, card_type)


func _on_update_chat(data) -> void:
	if !data:
		return
	var player_id: int = data["player_id"] if data.has("player_id") else -1
	var message: String = data["message"] if data.has("message") else ""
	var text: String = ""
	if player_id != -1:
		text += "[b][color=#%s]%s:[/color][/b] " % [AppManager.players_colors[player_id - 1].to_html(), get_player_by_id(player_id).get_username()]
	if message:
		text += "%s" % [message]
	emit_signal("update_chat", text)


func _on_quit_game() -> void:
	pass


################################################################################
func start_timer(timer: Node, wait_time: int):
	timer.stop()
	timer.one_shot = true
	timer.wait_time = wait_time
	timer.start()

