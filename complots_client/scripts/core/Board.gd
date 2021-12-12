class_name Board
################################################################################
#                                   SIGNALS                                    #
################################################################################
# Game Loop resume signals
signal player_action_valid()
"""Signal emitted when the active player made a valid action or the timer runout."""

signal player_card_choice_valid(cards)
"""
Signal: player_card_choice_valid

Signal emitted when a player choose a valid card. Example of use: dealing cards to 2 players or in the Ambassador's action.

:param Array cards: Array containing the selected card(s).
"""

signal player_option_choice_valid(options)
"""
Signal: player_option_choice_valid

Signal emitted when a player choose a valid option. Example of use: in the Captain's action.

:param Array options: Array containing the selected option(s).
"""

signal resume()
"""Signal to resume the game loop, called on timeout, etc."""

# Game Loop info signals
signal begin_turn()
"""Signal emitted when it is the beginning of a turn."""

signal end_turn()
"""Signal emitted when it is the end of a turn."""

signal update_history(message)
"""
Signal: update_history

Signal to update server's log in players chat.

:param String message: Message to display.
"""

signal distribution_complete()
"""Signal emitted when the distribution phase is complete."""

signal game_over()
"""Signal emitted when the game is over."""

# Game Loop player reaction signals (ex: Doubt, Counter)
signal start_reaction(action)
"""
Signal: start_reaction

This signal is emitted to all players, to let them know they can react to the action passed with it.

:param Action action: Action to react to.
"""

signal end_reaction()
"""Signal emitted when players are not allowed to react to the action anymore."""

# Game Loop barrier for action resolution
signal end_procedure()
"""Signal called when the kill_card procedure is complete."""

signal end_action()
"""Signal emitted to the board itself when an action is resolved."""

signal end_action_stack()
"""Signal emitted when the action stack is fully resolved."""

# Broadcast signals
signal resolved_action(action)
"""
Signal: resolved_action

Signal emitted to all players when an action is resolved. So they can update the game state.

:param Action action: The resolved action.
"""

signal player_loose_card(player_id, card_type)
"""
Signal: player_loose_card

Signal emitted when a player's card has been killed.

:param int player_id: The ID of the player that lost a card.
:param int card_type: The card type of the lost card.
"""


################################################################################
#                                  ATTRIBUTES                                  #
################################################################################
var _player_count: int
"""The number of players in the game."""

var _players: Array # Elements of type: Player_Base
"""Array of all players."""

var _deck: Array # Elements of type: Card
"""The deck of the game."""

var _roles: Array # Elements of type: int
"""Array containing all allowed cards for the game."""

var _actions: Array # Elements of type: Action
"""Stack of action, it is resolved each turn."""

var _active_player_id: int
"""The ID of the current playing player."""

var _turn_count: int
"""The number of turns of the game."""

var _bluff_timer: Timer # Timer Node
"""Timer Node to stop reaction phase after a given amount of time."""

var _action_timer: Timer # Timer Node
"""Timer Node to stop play_turn phase after a given amount of time."""

var _pass_count: int
"""Count how many players pass the reaction phase."""


const DEFAULT_ROLES: Array = [
	Card.CARD_TYPE.DUKE,
	Card.CARD_TYPE.ASSASSIN,
	Card.CARD_TYPE.CONTESSA,
	Card.CARD_TYPE.CAPTAIN,
	Card.CARD_TYPE.AMBASSADOR,
]
"""
Const: DEFAULT_ROLES

The default cards for a game of Complots.

.. code-block:: python

	const DEFAULT_ROLES: Array = [
		Card.CARD_TYPE.DUKE,
		Card.CARD_TYPE.ASSASSIN,
		Card.CARD_TYPE.CONTESSA,
		Card.CARD_TYPE.CAPTAIN,
		Card.CARD_TYPE.AMBASSADOR,
	]


:param Array DEFAULT_ROLES:
"""

################################################################################
# Constructor
# Class : Board
# Default values :
#     player_count = -1 : By default invalid player count
#     roles = [1, 2, 3, 4, 5] : By default basic Complots game with
#                                     Ambassador, without Inquisitor.
func _init(player_count: int = -1,
			roles: Array = DEFAULT_ROLES,
			action_timer: Timer = null,
			bluff_timer: Timer = null):
	var _s # Top with the warnings for surefire events
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

################################################################################
#                               PUBLIC FUNCTIONS                               #
################################################################################
func add_player(player: Player_Base) -> int:
	"""
	Method: add_player

	Method called after the constructor to add a player to the game.

	:param Player_Base player: The player to add to the game.
	:return int: Returns the ID of the player.
	"""
	# If already at max player capacity don't add an other one
	if _players.size() >= _player_count:
		return -1
	# Core signals
	var _s # Top with the warnings for surefire events
	_s = self.connect("end_reaction", player, "_on_end_reaction")
	_s = self.connect("start_reaction", player, "_on_start_reaction")
	_s = self.connect("resolved_action", player, "_on_resolved_action")
	_s = self.connect("player_loose_card", player, "_on_player_loose_card")
	_s = player.connect("player_action", self, "_on_player_action")
	_s = player.connect("player_reaction", self, "_on_player_reaction")
	_s = player.connect("player_card_choice", self, "_on_player_card_choice")
	_s = player.connect("player_option_choice", self, "_on_player_option_choice")
	player._id = _players.size() + 1
	_players.push_back(player)
	# Return player id
	return player._id

#------------------------------------------------------------------------------#
# Game Loop Function
func run() -> void:
	"""
	Method: run

	Method to start and run the game.

	:return void:
	"""
	var _s
	_init_game()
	if _player_count == 2:
		yield(self, "distribution_complete")
	print("========================================")
	print("Running Game!")
	_print_players() # DEBUG
	# Game Loop
	while !is_game_over():
		emit_signal("begin_turn")
		_add_action(Action.new(Action.ACTION_TYPE.START, 0, [0]))
		# Start timer in case active player doesn't respond in time
		_start_timer(_action_timer, Action.ACTION_TIMEOUT, "_on_action_timeout")
		# Ask active player to make an action
		get_active_player().play_turn(get_all_players_data())
		# Wait for active player's action or wait for the timer to timeout
		yield(self, "player_action_valid")
		# Stop the timer to make sure it doesn't add an action twice
		_stop_timer(_action_timer, "_on_action_timeout")
		# Get active player's action 
		var played_action: Action = get_action()
		# Start timer to let players doubt, counter or pass
		if !played_action._can_be_countered and !played_action._can_be_doubted:
			_start_timer(_bluff_timer, Action.ACTION_SHORT_TIMEOUT, "_on_bluff_timeout")
		else:
			_start_timer(_bluff_timer, Action.ACTION_TIMEOUT, "_on_bluff_timeout")
		# Wait until "resume" signal is called.
		# It's called from this class, when all players repond to
		# the action signal or the timer timeout.
		yield(self, "resume")
		# Stop the timer to make sure it doesn't add a reaction twice
		_bluff_timer.stop()
		# Resolve action stack
		call_deferred("_resolve_actions")
		yield(self,"end_action_stack")
		# End current turn
		_end_turn()
		_print_players() # DEBUG
	print("========================================")
	print("End of Game!")
	emit_signal("game_over")

func is_game_over() -> bool:
	"""
	Method: is_game_over

	Getter to know if the game is over (all players are dead except one).

	:return bool: Returns ``true`` if the gama is over else ``false``.
	"""
	return _count_alive_players() <= 1

################################################################################
#                              PRIVATE FUNCTIONS                               #
################################################################################
func _validate_roles() -> void:
	"""
	Method: _validate_roles

	Method called by the constructor to make sure the role array is valid.

	:return void:
	"""
	var valid: bool = true
	for role in _roles:
		if role <= Card.CARD_TYPE.HIDDEN or role >= Card.CARD_TYPE.INVALID:
			valid = false
			break
	if !valid or _roles.size() != 5:
		_roles = DEFAULT_ROLES

#------------------------------------------------------------------------------#
# Game Functions
#------------------------------------------------------------------------------#
# Game Initialisation Function
func _init_game() -> void:
	"""
	Method: _init_game

	Game initialisation method called at the beginning of the ``run`` method.

	:return void:
	"""
	print("========================================")
	print("Game Initialization!")
	_create_deck()
	_deal_coins()
	_deal_cards()
	for player in _players:
		if player is Bot:
			player.init_game_data(_players)

# Function to create deck
func _create_deck() -> void:
	"""
	Method: _create_deck

	Method to create the deck depending on the ``_player_count`` property.

	:return void:
	"""
	print("========================================")
	print("Creating Deck!")
	var nb_cards: int = 4 if _player_count >= 7 else 3
	for character in _roles:
		for _i in range(nb_cards):
			_deck.push_back(Card.new(character))
	_shuffle_deck()

func _shuffle_deck() -> void:
	"""
	Method: _shuffle_deck

	Method to shuffle the deck.

	:return void:
	"""
	print("Shuffling Deck!")
	_deck.shuffle()

func _deal_cards() -> void:
	"""
	Method: _deal_cards

	Helper method to deal cards based on player count.

	:return void:
	"""
	if _player_count == 2:
		_deal_cards_two_players()
	else:
		_deal_cards_basic()

func _deal_cards_basic() -> void:
	"""
	Method: _deal_cards_basic

	Method to deal 2 cards to each players.

	:return void:
	"""
	print("Dealing Cards!")
	for player in _players:
		for _i in range(2):
			var card: Card = _deck.pop_back()
			player.add_card(card)

func _deal_cards_two_players() -> void:
	"""
	Method: _deal_cards_two_players

	Method to deal 1 card to both players and let them choose the second card.

	:return void:
	"""
	print("Dealing Cards! (two players)")
	var cards : Array
	var choice : int
	_action_timer.one_shot = true
	for player in _players:
		player.add_card(_deck.pop_back())
	for player in _players:
		cards = []
		for _i in range(0,5):
			cards.push_back(_deck.pop_back())
		_start_timer(_action_timer, Action.ACTION_TIMEOUT, "_on_choice_timeout")
		player.select_cards(cards, 1, "Draw one of the following cards")
		choice = yield(self, "player_card_choice_valid")[0]
		_stop_timer(_action_timer, "_on_choice_timeout")
		player.add_card(cards[choice])
		for i in range(0,4):
			if i != choice:
				_deck.push_front(cards.pop_back())
		emit_signal("end_turn")
	_shuffle_deck()
	emit_signal("distribution_complete")

func _deal_coins() -> void:
	"""
	Method: _deal_coins

	Method to deals coins to all players. There is a difference between 2 players and more.

	:return void:
	"""
	# For 2 players game - the first player gets 1 coin instead of 2
	if _player_count == 2:
		_players[0].set_balance(1)
		_players[1].set_balance(2)
	# Give 2 coins to each players
	else:
		for player in _players:
			player.set_balance(2)

func _count_alive_players() -> int:
	"""
	Method: _count_alive_players

	Method to count alive players.

	:return int: Number of alive players.
	"""
	var alive_players: int = 0
	for player in _players:
		if player.is_alive():
			alive_players += 1
	return alive_players

func _reset_pass_counter() -> void:
	"""
	Method: _reset_pass_counter

	Method to reset pass counter.

	:return void:
	"""
	_pass_count = 0
	for player in _players:
		player._passed = false

func get_all_players_data() -> Dictionary:
	"""
	Method: get_all_players_data

	Method to get a dictionary with the minimum info about a player. Returns the following dictionary example:

	.. code-block:: python

		players_data {
			"alive": {
				1: {"username": "Player_1", "balance": 3},
				2: {"username": "Player_2", "balance": 5},
			},
			"dead": {
				3: {"username": "Player_3", "balance": 4},
			},
		}

	:return Dictionary: The dictionary containing all players data.
	"""
	var alive_players: Dictionary = {}
	var dead_players: Dictionary = {}
	for player in _players:
		if player.is_alive():
			alive_players[player.get_id()] = {
				"username": player.get_username(),
				"balance": player.get_balance(),
			}
		else:
			dead_players[player.get_id()] = {
				"username": player.get_username(),
				"balance": player.get_balance(),
			}
	return {"alive": alive_players, "dead": dead_players}

func _end_turn() -> void:
	"""
	Method: _end_turn

	Method to end the turn, change active player and send a signal to the players.

	:return void:
	"""
	print("End of turn")
	emit_signal("end_turn")
	_turn_count += 1
	_active_player_id = (_active_player_id % _player_count) + 1
	# Makes sure active player is alive
	while(!get_active_player().is_alive()):
		_active_player_id = (_active_player_id % _player_count) + 1

#------------------------------------------------------------------------------#
# Signals Functions
#------------------------------------------------------------------------------#
# Function called by the active player
func _on_player_action(action: Action) -> void:
	"""
	Method: _on_player_action

	Method called by the active player through the ``player_action`` signal.

	:param Action action: The player's action.
	:return void:
	"""
	if _is_action_valid(action):
		_add_action(action)
	else:
		_add_action(Action.new(Action.ACTION_TYPE.INCOME, _active_player_id, [0]))
	emit_signal("player_action_valid")

func _on_player_card_choice(index: Array) -> void:
	"""
	Method: _on_player_card_choice

	Method called by a player through the ``player_card_choice`` signal when the player has made his choice.

	:param Array index: The chosen card's index.
	:return void:
	"""
	if index.size() > 0:
		print("Received choice ", index)
		emit_signal("player_card_choice_valid", index)

func _on_player_option_choice(index: Array) -> void:
	"""
	Method: _on_player_option_choice

	Method called by a player through the ``player_option_choice`` signal when the player has made his choice.

	:param Array index: The chosen option's index.
	:return void:
	"""
	if index.size() > 0:
		print("Received option ", index)
		emit_signal("player_option_choice_valid", index)

func _on_player_reaction(action: Action) -> void:
	"""
	Method: _on_player_reaction

	This method can be called by any player during reaction phase through the ``player_reaction`` signal.

	:param Action action: The reaction made by the reacting player.
	:return void:
	"""
	if _is_action_valid(action):
		_add_action(action)

#------------------------------------------------------------------------------#
# Timer Functions
#------------------------------------------------------------------------------#
func _start_timer(timer: Timer, wait_time: int, callback: String) -> void:
	"""
	Method: _start_timer

	Helper method to start a timer with wait_time seconds and connect ``timeout`` signal.

	:param Timer timer: The timer node to use to countdown.
	:param int wait_time: The time to wait.
	:param String callback: The method to call on ``timeout``.
	:return void:
	"""
	timer.stop()
	timer.one_shot = true
	timer.wait_time = wait_time
	if !timer.is_connected("timeout", self, callback):
		var _s = timer.connect("timeout", self, callback)
	timer.start()

func _stop_timer(timer: Timer, callback: String) -> void:
	"""
	Method: _stop_timer

	Helper method to stop a timer and disconnect ``timeout`` signal.

	:param Timer timer: The timer node to stop the countdown.
	:param String callback: The method to disconnect.
	:return void:
	"""
	timer.stop()
	if timer.is_connected("timeout", self, callback):
		timer.disconnect("timeout", self, callback)

func _on_action_timeout() -> void:
	"""
	Method: _on_action_timeout

	Callback method called when active player didn't answer to the call to ``play_turn()``.

	:return void:
	"""
	print("Adding INCOME action") # DEBUG
	if get_active_player().get_balance() < 10:
		_add_action(Action.new(Action.ACTION_TYPE.INCOME, _active_player_id, [0]))
	else:
		# Choose a random target to make COUP
		var target_id: int = (randi() % _player_count) + 1
		while(target_id == _active_player_id or !get_player_by_id(target_id).is_alive()):
			target_id = (target_id % _player_count) + 1
		_add_action(Action.new(Action.ACTION_TYPE.COUP, _active_player_id, [target_id]))
	_add_action(Action.new(Action.ACTION_TYPE.END, 0, [0]))
	emit_signal("player_action_valid")

func _on_bluff_timeout() -> void:
	"""
	Method: _on_bluff_timeout

	Callback method called when players didn't react to active player action.

	:return void:
	"""
	print("Adding END action") # DEBUG
	_add_action(Action.new(Action.ACTION_TYPE.END, 0, [0]))
	emit_signal("resume")

func _on_choice_timeout() -> void:
	"""
	Method: _on_choice_timeout

	Callback method called when the player didn't made a choice.

	:return void:
	"""
	print("Choice timeout")
	emit_signal("player_card_choice_valid", [0])

func _on_option_timeout() -> void:
	"""
	Method: _on_option_timeout

	Callback method called when the player didn't choose an option.

	:return void:
	"""
	print("Option timeout")
	emit_signal("player_option_choice_valid", [0])

#==============================================================================#
# Action Function
#==============================================================================#
func _add_action(action: Action) -> void:
	"""
	Method: _add_action

	Method to add an action to the action stack.

	:param Action action: Action to add to the action stack.
	:return void:
	"""
	# If action is type END then add it and exit this function
	if action.get_action_type() == Action.ACTION_TYPE.END or \
		action.get_action_type() == Action.ACTION_TYPE.START:
		_actions.push_back(action)
		return
	# If action is of type PASS
	if action.get_action_type() == Action.ACTION_TYPE.PASS:
		var sender: Player_Base = get_player_by_id(action.get_sender_id())
		# If player have not already passed
		if !sender.has_passed():
			sender._passed = true
			_pass_count += 1
			# If all players - 1 (the one who made the main action)
			if _pass_count == _count_alive_players() - 1:
				# Then stop _bluff_timer
				_bluff_timer.stop()
				# Call the callback function of _bluff_timer
				_on_bluff_timeout()
			return
	_reset_pass_counter()
	var last_action: Action = get_action()
	# If first action add it, emit signal and exit this function
	if last_action.get_action_type() == Action.ACTION_TYPE.START:
		_actions.push_back(action)
		_emit_action(action)
		return
	# If previous action is of type END, then don't add the action then exit
	if get_action().get_action_type() == Action.ACTION_TYPE.END or \
		((get_action().get_action_type() == Action.ACTION_TYPE.DOUBT or get_action().get_action_type() == Action.ACTION_TYPE.COUNTER) and get_action().get_action_type() == action.get_action_type()):
		return
	# If this action is sent by the same player than the previous action then
	# exit the function
	if last_action.get_sender_id() == action.get_sender_id():
		return
	# If the action passed all test, add it to the action stack and emit its
	# signal
	_actions.push_back(action)
	_emit_action(action)

func _emit_action(action: Action) -> void:
	"""
	Method: _emit_action

	Method to emit the added action to all players.

	:param Action action: Action to emit to all players.
	:return void:
	"""
	# Stop bluff timer
	_bluff_timer.stop()
	# Emit signal to update the view
	emit_signal("update_history", get_action_message(action))
	# If action can't be countered nor doubted then timer is short
	if !action._can_be_countered and !action._can_be_doubted:
		_start_timer(_bluff_timer, Action.ACTION_SHORT_TIMEOUT, "_on_bluff_timeout")
	else: # Else timer is longer
		_start_timer(_bluff_timer, Action.ACTION_TIMEOUT, "_on_bluff_timeout")
	# If Action is of type Doubt then stop player reactions
	if action.get_action_type() == Action.ACTION_TYPE.DOUBT:
		emit_signal("end_reaction")
	else: # Else emit start_reaction signal
		emit_signal("start_reaction", action)

#------------------------------------------------------------------------------#
# Action Validity Check Functions
#------------------------------------------------------------------------------#
# Function to check if the action is valid
func _is_action_valid(action: Action) -> bool:
	"""
	Method: _is_action_valid

	Method to check if the action is valid.

	:param Action action: Action to check.
	:return bool: Returns ``true`` if the action is valid else ``false``.
	"""
	if action == null:
		return false
	var sender: Player_Base = get_player_by_id(action.get_sender_id())
	# If player is not valid or if he is dead
	if sender == null or !sender.is_alive():
		return false
	var previous_action: Action = get_action()
	# If it's the first action in the turn
	if previous_action.get_action_type() == Action.ACTION_TYPE.START:
		# Check if it's active player's action
		if action.get_sender_id() != _active_player_id:
			return false
		# Check if it's a main action
		if !Action.is_main_action(action):
			return false
	else: # If it's NOT the first action in the turn
		# If a player try to counter or doubt the main action but an other player already did
		if _actions.size() > 3 and action.get_targets_id()[0] == get_main_action().get_sender_id() and (action.get_action_type() == Action.ACTION_TYPE.COUNTER or action.get_action_type() == Action.ACTION_TYPE.DOUBT):
			return false
		# A player cannot play 2 actions in a row
		if previous_action.get_sender_id() == action.get_sender_id():
			return false
	# Check if targets are valid
	if !_check_target_validity(action.get_action_type(), action.get_targets_id()):
		return false
	if !_set_and_check_action_attributes(action):
		return false
	# All test passed successfuly, action is valid
	return true

func get_main_action() -> Action:
	"""
	Method: get_main_action

	Method to get the current main action.

	:return Action: Returns the current main action.
	"""
	for action in _actions:
		if Action.is_main_action(action):
			return action
	return null

func _check_target_validity(_action_type: int, _targets_id: Array) -> bool:
	"""
	Method: _check_target_validity

	Method to check whether the action corresponds to the targets it requires for its execution.

	:param int action_type: The action type of the action to check.
	:param Array targets_id: Array of targets ID to check.
	:return bool: Returns ``true`` if the targets are valid else ``false``.
	"""
	var ret: bool = true
	match _action_type:
		# Cannot assassinate more than 1 person, or nobody
		Action.ACTION_TYPE.DOUBT:
			ret = false if _targets_id.size() != 1 else true
		Action.ACTION_TYPE.COUNTER:
			ret = false if _targets_id.size() != 1 else true
		# Cannot assassinate/steal more than 1 person, or nobody
		Action.ACTION_TYPE.COUP:
			ret = false if _targets_id.size() != 1 or !_players[_targets_id[0] - 1].is_alive() else true
		Action.ACTION_TYPE.ASSASSIN:
			ret = false if _targets_id.size() != 1 or !_players[_targets_id[0] - 1].is_alive() else true
		Action.ACTION_TYPE.CAPTAIN:
			ret = false if _targets_id.size() != 1 or _players[_targets_id[0] - 1].get_balance() == 0 or !_players[_targets_id[0] - 1].is_alive() else true
		# The ambassador does not need a target to shine
		Action.ACTION_TYPE.AMBASSADOR:
			ret = false if _targets_id.size() > 1 or _deck.size() == 0 else true
		# The inquisitor does not need a target to shine...
		Action.ACTION_TYPE.INQUISITOR_1:
			ret = false if _targets_id.size() > 1 or _deck.size() == 0 else true
		# ...except to change an opponent's hand. But only one opponent.
		Action.ACTION_TYPE.INQUISITOR_2:
			ret = false if 	_targets_id.size() != 1 or !_players[_targets_id[0] - 1].is_alive() else true
	return ret

func _set_and_check_action_attributes(action: Action) -> bool:
	"""
	Method: _set_and_check_action_attributes

	Method to check check and correct action's attributes.

	:param Action action: The action to check.
	:return bool: Returns ``true`` if the attributes are valid else ``false``.
	"""
	var valid: bool = true
	match action.get_action_type():
		Action.ACTION_TYPE.DOUBT:
			action._can_be_countered = false
			action._can_be_doubted = false
		Action.ACTION_TYPE.COUNTER:
			action._can_be_countered = false
			action._can_be_doubted = true
		Action.ACTION_TYPE.FOREIGN_AID:
			action._can_be_countered = true
			action._can_be_doubted = false
		Action.ACTION_TYPE.COUP:
			action._can_be_countered = false
			action._can_be_doubted = false
			action._cost = 7
			valid = false if get_player_by_id(action.get_sender_id()).get_balance() < 7 else true
		Action.ACTION_TYPE.ASSASSIN:
			action._can_be_countered = true
			action._can_be_doubted = true
			action._cost = 3
			valid = false if get_player_by_id(action.get_sender_id()).get_balance() < 3 else true
		Action.ACTION_TYPE.CAPTAIN:
			action._can_be_countered = true
			action._can_be_doubted = true
			var target: Player_Base = get_player_by_id(action._targets_id[0])
			action._cost = 2 if target.get_balance() > 1 else 1
		Action.ACTION_TYPE.DUKE,\
		Action.ACTION_TYPE.AMBASSADOR,\
		Action.ACTION_TYPE.INQUISITOR_1,\
		Action.ACTION_TYPE.INQUISITOR_2:
			action._can_be_countered = false
			action._can_be_doubted = true
		_:
			action._can_be_countered = false
			action._can_be_doubted = false
			action._cost = 0
	return valid

#------------------------------------------------------------------------------#
# Functions to resolve actions
#------------------------------------------------------------------------------#
func _resolve_actions() -> void:
	"""
	Method: _resolve_actions

	Helper method to resolve all action stack.

	:return void:
	"""
	while _actions.size() > 0 and !is_game_over():
		call_deferred("_resolve_action")
		yield(self, "end_action")
	emit_signal("end_action_stack")

func _resolve_action() -> void:
	"""
	Method: _resolve_action

	Method to resolve the action on the top of the stack.

	:return void:
	"""
	emit_signal("end_reaction")
	var action: Action = _actions.back()
	var sender: Player_Base = get_player_by_id(action._sender_id)
	match action.get_action_type():
		Action.ACTION_TYPE.START:
			pass
		Action.ACTION_TYPE.END:
			pass
		#----------------------------------------------------------------------#
		# RESOLVE DOUBT
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.DOUBT:
			var previous_action: Action = _actions[_actions.size() - 2]
			var previous_sender: Player_Base = get_player_by_id(previous_action.get_sender_id())
			# If previous action was not a lie
			if previous_sender.has_card(previous_action.get_card_type()):
				call_deferred("kill_procedure",
							  sender,
							  "You doubted %s you lost, select a card to kill." % [previous_sender.get_username()],
							  "{player1} lost '[color=#95a5a6]%s[/color]' doubting {player2}'s action.".format({"player1": sender.get_bbusername(), "player2": previous_sender.get_bbusername()}))
				yield(self, "end_procedure")
				var previous_hand: Array = previous_sender.get_hand()
				var index: int = 0
				for card in previous_hand:
					if card.get_type() == previous_action.get_card_type():
						var player_card: Card = previous_hand[index]
						previous_sender.remove_card(index)
						previous_sender.add_card(_deck.pop_back())
						_deck.push_back(player_card)
						_shuffle_deck()
						break
					index += 1
			else: # If the previous action was a lie
				call_deferred("kill_procedure",
							  previous_sender,
							  "%s doubted you and you lied, select a card to kill." % [sender.get_username()],
							  "{player1} lied and lost '[color=#95a5a6]%s[/color]'.".format({"player1": previous_sender.get_bbusername()}))
				yield(self, "end_procedure")
				# Remove previous action
				_actions.pop_back()
		#----------------------------------------------------------------------#
		# RESOLVE COUNTER
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.COUNTER:
			# Remove the countered action
			var countered_action: Action = _actions[_actions.size() - 2]
			_actions.pop_back()
			emit_signal("update_history", "%s's counter was successful. Action '[color=#95a5a6]%s[/color]' was canceled." % [sender.get_bbusername(), Action.get_action_string(countered_action.get_action_type())])
		#----------------------------------------------------------------------#
		# RESOLVE INCOME
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.INCOME:
			sender.change_balance(1)
		#----------------------------------------------------------------------#
		# RESOLVE FOREIGN AID
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.FOREIGN_AID:
			sender.change_balance(2)
			emit_signal("update_history", "%s took 2 coins to the treasure." % [sender.get_bbusername()])
		#----------------------------------------------------------------------#
		# RESOLVE COUP
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.COUP:
			var target: Player_Base = get_player_by_id(action._targets_id[0])
			if !target.is_alive():
				_actions.pop_back()
				emit_signal("end_action")
				return
			call_deferred("kill_procedure",
						  target,
						  "%s assassinates one of your cards with a Coup." % [sender.get_username()],
						  "{player1} has killed {player2}'s '[color=#95a5a6]%s[/color]' with a Coup.".format({"player1": sender.get_bbusername(), "player2": target.get_bbusername()}))
			yield(self, "end_procedure")
			# Remove coins to sender
			sender.change_balance(-action.get_cost())
		#----------------------------------------------------------------------#
		# RESOLVE DUKE
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.DUKE:
			sender.change_balance(3)
			emit_signal("update_history", "%s took 3 coins to the treasure." % [sender.get_bbusername()])
		#----------------------------------------------------------------------#
		# RESOLVE ASSASSIN
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.ASSASSIN:
			var target: Player_Base = get_player_by_id(action._targets_id[0])
			if !target.is_alive():
				_actions.pop_back()
				emit_signal("end_action")
				return
			call_deferred("kill_procedure",
						  target,
						  "%s assassinates one of your cards using the ability of the Assassin." % [sender.get_username()],
						  "{player1} has killed {player2}'s '[color=#95a5a6]%s[/color]' with the ability of the [color=#95a5a6]Assassin[/color].".format({"player1": sender.get_bbusername(), "player2": target.get_bbusername()}))
			yield(self, "end_procedure")
			# Remove coins to sender
			sender.change_balance(-action.get_cost())
		Action.ACTION_TYPE.CONTESSA:
			pass
		#----------------------------------------------------------------------#
		# RESOLVE CAPTAIN
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.CAPTAIN:
			var target: Player_Base = get_player_by_id(action._targets_id[0])
			target.change_balance(-action._cost)
			sender.change_balance(action._cost)
			emit_signal("update_history", "%s stole %d %s from %s." % [sender.get_bbusername(), action.get_cost(), "coins" if action.get_cost() > 1 else "coin", target.get_bbusername()])
		#----------------------------------------------------------------------#
		# RESOLVE AMBASSADOR
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.AMBASSADOR:
			if !sender.is_alive():
				_actions.pop_back()
				emit_signal("end_action")
				return
			# Cards to send to the player
			var cards: Array = []
			# His choice (type int)
			var choice: Array = []
			# We add the drawn cards first, then the player's hand.
			# _deck ->	[0][1] | [2][3]	<- _hand
			for _i in range(2):
				cards.push_back(_deck.pop_front())
			for card in sender.get_hand():
				if !card.is_dead():
					cards.push_back(card)
			_start_timer(_action_timer, Action.ACTION_TIMEOUT, "_on_choice_timeout")
			sender.call_deferred("select_cards", cards, 2, "Select two cards to return to the Court.")
			choice = yield(self, "player_card_choice_valid")
			_stop_timer(_action_timer, "_on_choice_timeout")
			# If the player asks to reshuffle the card they've just drawn...
			var new_hand : Array = []
			print("Cards: ", cards)
			if choice.size() <= 1:
				choice = [0,1]
			# Rid the new hand of cards to reshuffle
			for i in range(0,4):
				# Skip if it's a dead card in hand
				# It should not be back in the deck
				if (i >= 2 and sender.get_hand()[i-2].is_dead()):
					continue
				# If it's a card chosen by the sender, put it back in the hand
				if i == choice[0] or i == choice[1]:
					print(i, " VS ", choice)
					_deck.push_back(cards[i])
				# If not, set it aside
				else:
					new_hand.push_back(i)
			# Put each card set aside in the player hand and remove the first card
			for card in new_hand:
				sender.call_deferred("add_card",(cards[card]))
				yield(sender,"hand_updated")
				sender.call_deferred("remove_card",(1 if sender.get_hand()[0].is_dead() else 0))
				yield(sender,"hand_updated")
				# The call must be synchronous or else glitches like removing only
				# one card or making the other player win automatically may occur!
		#----------------------------------------------------------------------#
		# RESOLVE INQUISITOR FIRST ABILITY
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.INQUISITOR_1:
			if !sender.is_alive():
				_actions.pop_back()
				emit_signal("end_action")
				return
			# Cards to send to the player
			var cards: Array = []
			# His choice (type int)
			var choice: Array = []
			# We add the drawn cards first, then the player's hand.
			# _deck ->	[0] | [1][2]	<- _hand
			cards.push_back(_deck.pop_back())
			for card in sender.get_hand():
				if !card.is_dead():
					cards.push_back(card)
			_start_timer(_action_timer, Action.ACTION_TIMEOUT, "_on_choice_timeout")
			sender.call_deferred("select_cards", cards, 1, "Select a card to return to the Court.")
			choice = yield(self, "player_card_choice_valid")
			_stop_timer(_action_timer, "_on_choice_timeout")
			# If the player asks to reshuffle the card they've just drawn...
			if choice[0] < 1:
				# Return the popped card to the deck
				_deck.push_back(cards.pop_front())
			else: #choice[0] >= 1
				# If the player asks to reshuffle their dead card (cheating)...
				if sender.get_hand()[choice[0] - 1].is_dead():
					# Reshuffle their other card
					print("Player reshuffles card %d (%s) in favour to %s" % [choice[0] % 2, sender.get_hand()[choice[0] % 2].get_name(), cards[0].get_name()])
					sender.call_deferred("remove_card",(choice[0] % 2))
				else: # Both cards are alive
					print("Player reshuffles card %d (%s) in favour to %s" % [choice[0] - 1, sender.get_hand()[choice[0] - 1].get_name(), cards[0].get_name()])
					sender.call_deferred("remove_card",(choice[0] - 1))
				sender.call_deferred("add_card",(cards[0]))
		#----------------------------------------------------------------------#
		# RESOLVE INQUISITOR SECOND ABILITY
		#----------------------------------------------------------------------#
		Action.ACTION_TYPE.INQUISITOR_2:
			var target: Player_Base = get_player_by_id(action._targets_id[0])
			var cards: Array
			var choice: Array = []
			if !target.is_alive() or !sender.is_alive():
				_actions.pop_back()
				emit_signal("end_action")
				return
			cards = target.get_hand()
			_start_timer(_action_timer, Action.ACTION_TIMEOUT, "_on_choice_timeout")
			target.call_deferred("select_cards", cards, 1, "Select 1 card to show to %s's Inquisitor" % [sender.get_username()])
			choice = yield(self, "player_card_choice_valid")
			_stop_timer(_action_timer, "_on_choice_timeout")
			target.call_deferred("stop_reaction")
			print("choice", choice)
			var card: Card = target.get_hand()[choice[0]]
			if typeof(card) == TYPE_NIL or card.is_dead():
				print("invalid")
				card = target.get_hand()[1 if target.get_hand()[0].is_dead() else 0]
				choice[0] = 1 if target.get_hand()[0].is_dead() else 0
				if card.is_dead():
					_actions.pop_back()
					emit_signal("end_action")
					return
			var options: Array = ["Leave it in their hand",
								  "Return it to the Court" ]
			var text: String = "The opponent has shown you their %s." % [card.get_name()]
			_start_timer(_action_timer, Action.ACTION_TIMEOUT, "_on_option_timeout")
			sender.call_deferred("branch_options", options, text)
			if yield(self,"player_option_choice_valid")[0] == 1:
				_deck.push_back(card)
				target.call_deferred("add_card",(_deck.pop_front()))
				yield(target,"hand_updated")
				target.call_deferred("remove_card",(choice[0]))
				yield(target,"hand_updated")
				emit_signal("update_history", "%s made %s exchange one card with the Court." % [sender.get_bbusername(), target.get_bbusername()])
			else:
				emit_signal("update_history", "%s let %s keep his card." % [sender.get_bbusername(), target.get_bbusername()])
			_stop_timer(_action_timer, "_on_option_timeout")
	_actions.pop_back()
	emit_signal("resolved_action", action)
	emit_signal("end_action")

func kill_procedure(player: Player_Base, ask_message: String, action_message: String) -> void:
	"""
	Method: kill_procedure

	Helper method to start a killing procedure.

	:param Player_Base player: The player object that we want to kill a card from.
	:param String ask_message: Message to display to the player.
	:param String action_message: Message to announce to all players that the player has lost a specific card.
	:return void:
	"""
	var victim: Array = []
	# Start timer in case sender doesn't respond in time
	_start_timer(_action_timer, Action.ACTION_TIMEOUT, "_on_choice_timeout")
	# Ask sender to kill one of it's card
	player.call_deferred("request_kill_card", ask_message, 1)
	# Wait for the respond
	victim = yield(self, "player_card_choice_valid")
	# Stop the timer to avoid duplicates
	_stop_timer(_action_timer, "_on_choice_timeout")
	# Kill selected card
	kill_player_card(player, victim, action_message % [player.get_hand()[victim[0]].get_name()])
	emit_signal("player_loose_card", player.get_id(), player.get_hand()[victim[0]].get_type())
	emit_signal("end_procedure")

func kill_player_card(player: Player_Base, victim: Array, message: String) -> void:
	"""
	Method: kill_player_card

	Helper method to kill a player card.

	:param Player_Base player: The player object that we want to kill a card from.
	:param Array victim: Array containing the card index to kill.
	:param String message: Message to display to all players.
	:return void:
	"""
	if victim.size() == 0:
		victim.push_back(1 if player.get_hand()[0].is_dead() else 0)
	if player.get_hand()[victim[0]].is_dead():
		victim[0] = 1 if player.get_hand()[0].is_dead() else 0
	player.kill_card(victim[0])
	emit_signal("update_history", message)

################################################################################
#                                   GETTERS                                    #
################################################################################
func get_player_count() -> int:
	return _player_count

func get_roles() -> Array:
	return _roles

func get_active_player_id() -> int:
	return _active_player_id

func get_active_player() -> Player_Base:
	return get_player_by_id(_active_player_id)

func get_players() -> Array:
	return _players

func get_player_by_id(id: int) -> Player_Base:
	"""
	Method: get_player_by_id

	Helper method to get the player object with the id passed as a parameter.

	:param int id: Player's ID.
	:return Player_Base: Returns the player object.
	"""
	for player in _players:
		if player._id == id:
			return player
	return null

func get_action() -> Action:
	return null if _actions.size() == 0 else _actions[_actions.size() - 1]

func get_actions() -> Array:
	return _actions

func get_action_message(action: Action) -> String:
	"""
	Method: get_action_message

	Method to get the formated action message.

	:param Action action: Action to get the message from.
	:return String: Returns the formated action's message.
	"""
	var message: String = ""
	var sender: Player_Base = get_player_by_id(action._sender_id)
	var target = get_player_by_id(action._targets_id[0])
	match action.get_action_type():
		Action.ACTION_TYPE.START:
			pass
		Action.ACTION_TYPE.END:
			pass
		Action.ACTION_TYPE.PASS:
			pass
		Action.ACTION_TYPE.DOUBT:
			message = "%s doubted %s's action." % [sender.get_bbusername(), target.get_bbusername()]
		Action.ACTION_TYPE.COUNTER:
			message = "%s countered %s with the card '[color=#95a5a6]%s[/color]'." % [sender.get_bbusername(), target.get_bbusername(), Card.get_card_name(action.get_card_type())]
		Action.ACTION_TYPE.INCOME:
			message = "%s take one coin from the treasure." % [sender.get_bbusername()]
		Action.ACTION_TYPE.FOREIGN_AID:
			message = "%s wants to take two coins from the treasure." % [sender.get_bbusername()]
		Action.ACTION_TYPE.COUP:
			message = "%s wants to kill %s with a Coup." % [sender.get_bbusername(), target.get_bbusername()]
		Action.ACTION_TYPE.DUKE:
			message = "%s wants to take three coins from the treasure using the '[color=#95a5a6]Duke[/color]'." % [sender.get_bbusername()]
		Action.ACTION_TYPE.ASSASSIN:
			message = "%s wants to kill %s with the ability of the '[color=#95a5a6]Assassin[/color]'." % [sender.get_bbusername(), target.get_bbusername()]
		Action.ACTION_TYPE.CONTESSA:
			message = "[color=#ff0000]Contessa doesn't have any action![/color]"
		Action.ACTION_TYPE.CAPTAIN:
			message = "%s wants to steal %d %s from %s using the '[color=#95a5a6]Captain[/color]'." % [sender.get_bbusername(), action.get_cost(), "coins" if action.get_cost() > 1 else "coin", target.get_bbusername()]
		Action.ACTION_TYPE.AMBASSADOR:
			message = "%s wants to use the ability of the '[color=#95a5a6]Ambassador[/color]' and exchange two of its card." % [sender.get_bbusername()]
		Action.ACTION_TYPE.INQUISITOR_1:
			message = "%s wants to use the ability of the '[color=#95a5a6]Inquisitor[/color]' and exchange one of its card." % [sender.get_bbusername()]
		Action.ACTION_TYPE.INQUISITOR_2:
			message = "%s wants to use the ability of the '[color=#95a5a6]Inquisitor[/color]' and look at one card of %s." % [sender.get_bbusername(), target.get_bbusername()]
		_:
			message = "Invalid Action"
	return message

#------------------------------------------------------------------------------#
# Debug Functions
#------------------------------------------------------------------------------#
func _print_deck() -> void:
	"""
	Method: _print_deck

	Debug method to print the deck.

	:return void:
	"""
	print("Printing Deck :")
	for card in _deck:
		print("[%s]"%card.get_name())

func _print_players() -> void:
	"""
	Method: _print_players

	Debug method to print all players data.

	:return void:
	"""
	for player in _players:
		player._print()
