extends Player_Base

class_name Bot
################################################################################
#                                   SIGNALS                                    #
################################################################################
signal wait_for_seconds(player, wait_time)
"""
Signal: wait_for_seconds

Signal to wait for <wait_time> seconds.

:param Player player: The player object itself.
:param int wait_time: Amount of time to wait.
"""

signal resume_wait()
"""Signal send after the wait time is over."""

################################################################################
#                                 ENUMERATIONS                                 #
################################################################################
enum BOT_DIFFICULTY {
	EASY = 0,
	MEDIUM = 1,
	HARD = 2,
}
"""
Enum: BOT_DIFFICULTY

Enumeration to store bot difficulty level in a human readable way.

:param EASY: Bot difficulty ``easy``.
:param MEDIUM: Bot difficulty ``medium``.
:param HARD: Bot difficulty ``hard``.
"""

################################################################################
#                                  ATTRIBUTES                                  #
################################################################################
var _game_data: Dictionary
"""
Property: _game_data

Bots must have a way to store players actions, balance, if they're dead, most likely cards in their hands, ... All this data is stored in _game_data, it's a Dictionary, it has the following structure (it's an example) :

.. code-block:: python

	_game_data = {
		"players": {
			1: {
				"is_alive": true,
				"balance": 3,
				"is_bot": false,
				"hand": [
					{"card_type": Card.CARD_TYPE.DUKE, "is_dead": false },
					{"card_type": Card.CARD_TYPE.CONTESSA, "is_dead": true}
				],
				"announcement": {
					Card.CARD_TYPE.HIDDEN: 0,
					Card.CARD_TYPE.DUKE: 0,
					Card.CARD_TYPE.ASSASSIN: 0,
					Card.CARD_TYPE.CONTESSA: 0,
					Card.CARD_TYPE.CAPTAIN: 0,
					Card.CARD_TYPE.AMBASSADOR: 0,
				}
			}
		},
		"current_main_action": null, # Main action of this turn, ex: FOREIGN_AID
		"calling_action": null, # Last action of this turn, ex: COUNTER
	}

:param Dictionary _game_data:
"""

var _bot_difficulty: int
"""The difficulty of the bot."""

var _min_select_time: Array = [
	1.5, # Easy
	1.5, # Medium
	1.5, # Hard
]
"""
Property: _min_select_time

Minimum time to select a card to kill, select a target, ...

:param Array _min_select_time:
"""

var _max_select_time: Array = [
	2.5, # Easy
	2.5, # Medium
	2.5, # Hard
]
"""
Property: _max_select_time

Maximum time to select a card to kill, select a target, ...

:param Array _max_select_time:
"""

var _min_action_time: Array = [
	5, # Easy
	5, # Medium
	5, # Hard
]
"""
Property: _min_action_time

Minimum time to select the bot action.

:param Array _min_action_time:
"""

var _max_action_time: Array = [
	7, # Easy
	7, # Medium
	7, # Hard
]
"""
Property: _max_action_time

Maximum time to select the bot action.

:param Array _max_action_time:
"""

var _min_reaction_time: Array = [
	8, # Easy
	8, # Medium
	8, # Hard
]
"""
Property: _min_reaction_time

Minimum Time to react to an action, COUNTER, DOUBT, PASS

:param Array _min_reaction_time:
"""

var _max_reaction_time: Array = [
	10, # Easy
	10, # Medium
	10, # Hard
]
"""
Property: _max_reaction_time

Maximum Time to react to an action, COUNTER, DOUBT, PASS

:param Array _max_reaction_time:
"""

################################################################################
# Constructor
# Class : Player
# Default values :
#     id = -1 : By default invalid player id
#     username = "" : By default empty player username
func _init(id: int = -1, username: String = "", color: String = "#ffffff", roles: Array = [1, 2, 3, 4, 5], bot_difficulty: int = 0):
	_id = id if id > 0 else -1
	_username = username
	_balance = 0
	_hand = []
	_game_data = {
		"players": {},
		"current_main_action": null,
		"calling_action": null,
	}
	_color = color
	_action = null
	_passed = false
	_roles = roles
	_bot_difficulty = bot_difficulty
	print("Creation of Bot \"%s\" with ID: %d"%[_username, _id])

func init_game_data(players: Array) -> void:
	"""
	Method: init_game_data

	This method is used to initialize the bot's _game_data dictionary.

	:param Array players: List of all players in the game.
	:return void:
	"""
	for player in players:
		if player.get_id() != get_id():
			_game_data["players"][player.get_id()] = {
				"is_alive": player.is_alive(),
				"balance": player.get_balance(),
				"is_bot": player.is_class("Bot"),
				"hand": [
					{"card_type": 0, "is_dead": player.get_hand()[0].is_dead()},
					{"card_type": 0, "is_dead": player.get_hand()[1].is_dead() if player.get_hand().size() > 1 else false}
				],
				"announcement": {0: 0}
			}
			for role in _roles:
				_game_data["players"][player.get_id()]["announcement"][role] = 0

################################################################################
#                               PUBLIC FUNCTIONS                               #
################################################################################
#------------------------------------------------------------------------------#
# Called from Board: Custom Setters
#------------------------------------------------------------------------------#
# Override to hide cards from player
func add_card(card: Card) -> void:
	"""
	Method: add_card

	Override: This method is used to add a card to the player's hand.

	:param Card card: Card to add to the player's hand.
	:return void:
	"""
	print("add_card")
	_hand.push_back(card)
	emit_signal("add_card", Card.new(Card.CARD_TYPE.HIDDEN), _hand)

#------------------------------------------------------------------------------#
# Game Loop function
#------------------------------------------------------------------------------#
func play_turn(players_data: Dictionary) -> void:
	"""
	Method: play_turn
	
	Called from `Board`: Method that requests an action from a player when it's their turn to play.
	
	:param Dictionary players_data: Dictionary containing the minimum info needed to play.
	:return void: The return is made by the signal: 'player_action'.
	"""
	_action = null
	var wait_time: float = rand_range(_min_action_time[_bot_difficulty], _max_action_time[_bot_difficulty])
	emit_signal("wait_for_seconds", self, wait_time)
	yield(self, "resume_wait")
	match _bot_difficulty:
		BOT_DIFFICULTY.EASY:
			play_turn_easy(players_data)
		BOT_DIFFICULTY.MEDIUM:
			play_turn_medium(players_data)
		BOT_DIFFICULTY.HARD:
			play_turn_hard(players_data)
		_:
			play_turn_easy(players_data)
	emit_signal("player_action", _action)

func select_cards(cards: Array, qty: int = 1, _text: String = "", select_type: int = Action.SELECT_TYPE.KEEP) -> void:
	"""
	Method: select_cards
	
	Called from `Board`: Method that requests a choice of cards from the player.
	
	:param Array cards: Array of cards to choose from.
	:param int qty: Quantity of cards to choose.
	:param String text: Text to display to the player.
	:return void: The return is made by the signal: 'player_card_choice'.
	"""
	var wait_time: float = rand_range(_min_select_time[_bot_difficulty], _max_select_time[_bot_difficulty])
	emit_signal("wait_for_seconds", self, wait_time)
	yield(self, "resume_wait")
	var selection : Array = []
	match _bot_difficulty:
		BOT_DIFFICULTY.EASY:
			selection = select_cards_easy(cards, qty, select_type)
		BOT_DIFFICULTY.MEDIUM:
			selection = select_cards_medium(cards, qty, select_type)
		BOT_DIFFICULTY.HARD:
			selection = select_cards_hard(cards, qty, select_type)
		_:
			selection = select_cards_easy(cards, qty, select_type)
	emit_signal("player_card_choice", selection)

func branch_options(options: Array, _text: String, card_type: int) -> void:
	"""
	Method: branch_options
	
	Called from `Board`: Method that requests a player to pick an option in a list.
	
	:param Array options: Array of options to choose from.
	:param String text: Text to display to the player.
	:return void: The return is made by the signal: 'player_option_choice'.
	"""
	var wait_time: float = rand_range(_min_select_time[_bot_difficulty], _max_select_time[_bot_difficulty])
	emit_signal("wait_for_seconds", self, wait_time)
	yield(self, "resume_wait")
	var value: int
	match _bot_difficulty:
		BOT_DIFFICULTY.EASY:
			value = branch_options_easy(options, card_type)
		BOT_DIFFICULTY.MEDIUM:
			value = branch_options_medium(options, card_type)
		BOT_DIFFICULTY.HARD:
			value = branch_options_hard(options, card_type)
		_:
			value = branch_options_easy(options, card_type)
	emit_signal("player_option_choice", value)

func request_kill_card(_text: String = "", qty: int = 1, _select_type: int = Action.SELECT_TYPE.KILL) -> void:
	"""
	Method: request_kill_card
	
	Called from `Board`: Method that requests a victim from the player.
	
	:param String text: Text to display to the player.
	:param int qty: Quantity of cards to kill.
	:return void: The return is made by the signal: 'player_card_choice'.
	"""
	var wait_time: float = rand_range(_min_select_time[_bot_difficulty], _max_select_time[_bot_difficulty])
	emit_signal("wait_for_seconds", self, wait_time)
	yield(self, "resume_wait")
	var cards : Array = []
	var selection : Array = []
	for card in _hand:
		cards.push_back(card)
	match _bot_difficulty:
		BOT_DIFFICULTY.EASY:
			selection = request_kill_card_easy(cards, qty)
		BOT_DIFFICULTY.MEDIUM:
			selection = request_kill_card_medium(cards, qty)
		BOT_DIFFICULTY.HARD:
			selection = request_kill_card_hard(cards, qty)
		_:
			selection = request_kill_card_easy(cards, qty)
	emit_signal("player_card_choice", selection)

################################################################################
#                              PRIVATE FUNCTIONS                               #
################################################################################
#------------------------------------------------------------------------------#
# Signals Functions
#------------------------------------------------------------------------------#
func _on_start_reaction(calling_action: Action, _time: int) -> void:
	"""
	Method: _on_start_reaction
	
	Called from `Board`: Method that ask the view to make a reaction.
	
	:param Action calling_action: Action made by the current player. Action to react to.
	:return void: The return is made by the signal: 'player_reaction'.
	"""
	_passed = false
	if calling_action._sender_id == _id or !is_alive():
		emit_signal("end_turn")
		return
	_process_action(calling_action)
	_action = null
	var wait_time: float = rand_range(_min_reaction_time[_bot_difficulty], _max_reaction_time[_bot_difficulty])
	emit_signal("wait_for_seconds", self, wait_time)
	yield(self, "resume_wait")
	if !calling_action._can_be_countered and !calling_action._can_be_doubted:
		return
	match _bot_difficulty:
		BOT_DIFFICULTY.EASY:
			_on_start_reaction_easy(calling_action)
		BOT_DIFFICULTY.MEDIUM:
			_on_start_reaction_medium(calling_action)
		BOT_DIFFICULTY.HARD:
			_on_start_reaction_hard(calling_action)
		_:
			_on_start_reaction_easy(calling_action)

func _on_resume_wait() -> void:
	"""
	Method: _on_resume_wait
	
	Method that calls the signal ``resume_wait`` after the wait time is over.
	
	:return void:
	"""
	emit_signal("resume_wait")

func _on_resolved_action(action: Action) -> void:
	"""
	Method: _on_resolved_action
	
	Method called by the `Board` to update the _game_data.
	
	:param Action action: The action that has just been resolved.
	:return void:
	"""
	_process_resolved_action(action)
################################################################################
# LINK TO THE INTERFACE
################################################################################
func connect_signals(view: Node) -> void:
	"""
	Method: connect_signals
	
	Method to link all needed signals between the bot and its view. 
	
	:param Node view: Node that represents the player.
	:return void:
	"""
	var _s # Top with the warnings for surefire events
	########################################################################
	# CORE SIGNALS ALL MUST BE IMPLEMENTED TO LET PLAYER PLAY THE GAME
	########################################################################
	# Core: Wait for seconds to let other players playe
	_s = self.connect("wait_for_seconds", view, "_on_wait_for_seconds")
	# Core: Function to call when finishing adding / removing / killing a
	# player card
	_s = view.connect("hand_updated", self, "_on_hand_updated")
	########################################################################
	# View Signals
	########################################################################
	# Interface: Signal when a player card has just been killed (update visual)
	_s = self.connect("kill_card", view, "_on_kill_card")
	# Interface: Signal called when the player is ready (when he received his coins)
	_s = self.connect("init_player", view, "_on_init_player")
	# Interface: Signal called when player balance is changed (update visual)
	_s = self.connect("change_balance", view, "_on_change_balance")
	# Interface: Signal called when a card is added to the player hand
	_s = self.connect("add_card", view, "_on_add_card")
	# Interface: Signal called when a card is removed from the player hand
	_s = self.connect("remove_card", view, "_on_remove_card")
	# Interface: Signal called when the player cannot react anymore to the current action
	_s = self.connect("end_reaction", view, "_on_end_reaction")
	# Interface: Signal called when it's the end of the player's turn
	_s = self.connect("end_turn", view, "_on_end_turn")
	# Interface: Signal when the action is sent to the board (you can disable action selection)
	_s = self.connect("player_action", view, "_on_player_action")
	# Interface: Signal to hide player reaction screen (or disable reaction buttons)
	_s = self.connect("stop_reaction", view, "_on_stop_reaction")

################################################################################
# BOT AI: Game Data Functions
################################################################################
#------------------------------------------------------------------------------#
# Function to keep the _game_date updated
#------------------------------------------------------------------------------#
func _process_action(action: Action) -> void:
	"""
	Method: _process_action
	
	Method to keep the _game_date updated.
	
	:param Action action: Action to process.
	:return void:
	"""
	var sender_id: int = action.get_sender_id()
	var card_type: int = action.get_card_type()
	var action_type: int = action.get_action_type()
	# Store action as calling_action
	_game_data["calling_action"] = action
	if action_type == Action.ACTION_TYPE.DOUBT:
		return
	# If action is a main action
	if Action.is_main_action(action):
		# Then add it as current_main_action
		_game_data["current_main_action"] = action
	# If action was made from a card (ex: INCOME is not made with a card)
	if card_type != 0:
		# Adding card to announcement array
		_game_data["players"][sender_id]["announcement"][card_type] += 1
		_update_player_data(sender_id)
	#_print_game_data()

func _update_player_data(sender_id: int) -> void:
	"""
	Method: _update_player_data
	
	Method to update the player's hand representation with the ID **sender_id** in the _game_data. The player's hand is an estimation.
	
	:param int sender_id: Player ID of the player to update.
	:return void:
	"""
	var hand: Array = _game_data["players"][sender_id]["hand"]
	var max_key1: int = hand[0]["card_type"]
	var max_key2: int = hand[1]["card_type"]
	var keys: Array = _game_data["players"][sender_id]["announcement"].keys()
	for key in keys:
		# if both cards are alive
		if !hand[0]["is_dead"] and !hand[1]["is_dead"]:
			# if key value is bigger than key2 value
			if _game_data["players"][sender_id]["announcement"][key] > _game_data["players"][sender_id]["announcement"][max_key2]:
				# Replace key
				max_key2 = key
				# Makes sure key1 value is bigger than key2 value
				if _game_data["players"][sender_id]["announcement"][max_key2] > _game_data["players"][sender_id]["announcement"][max_key1]:
					# Swap key1 and key2
					var tmp_key: int = max_key1
					max_key1 = max_key2
					max_key2 = tmp_key
		# if first card is alive and second is dead
		elif !hand[0]["is_dead"] and hand[1]["is_dead"]:
			# if key value is bigger than key1 value
			if _game_data["players"][sender_id]["announcement"][key] > _game_data["players"][sender_id]["announcement"][max_key1]:
				# Replace key
				max_key1 = key
		# if first card is dead and second is alive
		elif hand[0]["is_dead"] and !hand[1]["is_dead"]:
			# if key value is bigger than key2 value
			if _game_data["players"][sender_id]["announcement"][key] > _game_data["players"][sender_id]["announcement"][max_key2]:
				# Replace key
				max_key2 = key
		# Update player hand
		_game_data["players"][sender_id]["hand"][0]["card_type"] = max_key1
		_game_data["players"][sender_id]["hand"][1]["card_type"] = max_key2

func _process_resolved_action(action: Action) -> void:
	"""
	Method: _process_resolved_action
	
	Method to process a resolved action.
	
	:param Action action: Resolved action to process.
	:return void:
	"""
	var sender_id: int = action.get_sender_id()
	if sender_id == get_id():
		return
	match action.get_action_type():
		Action.ACTION_TYPE.INCOME:
			_game_data["players"][sender_id]["balance"] += 1
		Action.ACTION_TYPE.FOREIGN_AID:
			_game_data["players"][sender_id]["balance"] += 2
		Action.ACTION_TYPE.DUKE:
			_game_data["players"][sender_id]["balance"] += 3
		Action.ACTION_TYPE.COUP:
			_game_data["players"][sender_id]["balance"] -= 7
		Action.ACTION_TYPE.ASSASSIN:
			_game_data["players"][sender_id]["balance"] -= 3
		Action.ACTION_TYPE.CAPTAIN:
			var target_id: int = action.get_targets_id()[0]
			_game_data["players"][sender_id]["balance"] += action.get_cost()
			if target_id != get_id():
				_game_data["players"][target_id]["balance"] -= action.get_cost()
		_:
			pass

func _on_player_loose_card(player_id: int, card_type: int) -> void:
	"""
	Method: _on_player_loose_card
	
	Method to update _game_data.
	
	:param int player_id: The ID of the player that just lost a card.
	:param int card_type: The card type of the cart that has been killed.
	:return void:
	"""
	if player_id == get_id():
		return
	var card_index: int = 1
	if _game_data["players"][player_id]["hand"][0]["card_type"] == card_type:
		card_index = 0
	if _game_data["players"][player_id]["hand"][1]["card_type"] == card_type:
		card_index = 1
	_game_data["players"][player_id]["hand"][card_index]["card_type"] = card_type
	_game_data["players"][player_id]["hand"][card_index]["is_dead"] = true
	if _game_data["players"][player_id]["hand"][0]["is_dead"] and _game_data["players"][player_id]["hand"][1]["is_dead"]:
		_game_data["players"][player_id]["is_alive"] = false

func _print_game_data() -> void:
	"""
	Method: _print_game_data
	
	Debug method to print the _game_data of the bot.
	
	:return void:
	"""
	print("========================================")
	print("DATA OF BOT: %s" % get_username())
	print("---")
	print("'current_main_action': '%s'," % Action.get_action_string(_game_data["current_main_action"].get_action_type()))
	print("'calling_action': '%s'," % Action.get_action_string(_game_data["calling_action"].get_action_type()))
	print("'players': [")
	var player_keys: Array = _game_data["players"].keys()
	for player_key in player_keys:
		print("    %s: [" % player_key)
		print("        'is_alive': %s," % _game_data["players"][player_key]["is_alive"])
		print("        'balance': %d," % _game_data["players"][player_key]["balance"])
		print("        'is_bot': %s," % _game_data["players"][player_key]["is_bot"])
		print("        'hand': [")
		for card in _game_data["players"][player_key]["hand"]:
			print("            'card_type': %s," % Card.get_card_name(card["card_type"]))
			print("            'is_dead': %s," % card["is_dead"])
		print("        ],") # hand
		print("        'announcement': [")
		var announcement_keys: Array = _game_data["players"][player_key]["announcement"].keys()
		for announcement_key in announcement_keys:
			print("            %s: %d," % [Card.get_card_name(announcement_key), _game_data["players"][player_key]["announcement"][announcement_key]])
		print("        ],") # announcement
		print("    ],") # player
	print("]") # players

################################################################################
# BOT AI: Function
################################################################################
#------------------------------------------------------------------------------#
# play_turn functions
#------------------------------------------------------------------------------#
func play_turn_easy(players_data: Dictionary) -> void:
	"""
	Method: play_turn_easy
	
	Method to make an action for a bot with an ``easy`` level of difficulty.
	
	:param Dictionary players_data: Dictionary containing minimum amount of data about all other players.
	:return void: The return is made by affecting a new {Action} to the ``_action`` property.
	"""
	var rnd: int = randi() % 100
	var index: int = randi() % players_data["alive"].size()
	var alive_ids = players_data["alive"].keys()
	var target_id: int = alive_ids[index]
	while target_id == get_id():
		index = (index + 1) % alive_ids.size()
		target_id = alive_ids[index]
	# If player have more than 10 coins, he must make a COUP
	if get_balance() >= 10:
		# Select a random target within alive players
		_action = Action.new(Action.ACTION_TYPE.COUP, get_id(), [target_id])
	elif get_balance() >= 7 and rnd < 50:
		# Select a random target within alive players
		_action = Action.new(Action.ACTION_TYPE.COUP, get_id(), [target_id])
	elif rnd < 35:
		_action = Action.new(Action.ACTION_TYPE.FOREIGN_AID, get_id(), [0])
	else:
		_action = Action.new(Action.ACTION_TYPE.INCOME, get_id(), [0])

# TODO: Make AI decision here
func play_turn_medium(players_data: Dictionary) -> void:
	"""
	Method: play_turn_medium
	
	Method to make an action for a bot with a ``medium`` level of difficulty.
	
	:param Dictionary players_data: Dictionary containing minimum amount of data about all other players.
	:return void: The return is made by affecting a new {Action} to the ``_action`` property.
	"""
	play_turn_easy(players_data)

# TODO: Make AI decision here
func play_turn_hard(players_data: Dictionary) -> void:
	"""
	Method: play_turn_hard
	
	Method to make an action for a bot with a ``hard`` level of difficulty.
	
	:param Dictionary players_data: Dictionary containing minimum amount of data about all other players.
	:return void: The return is made by affecting a new {Action} to the ``_action`` property.
	"""
	play_turn_easy(players_data)

#------------------------------------------------------------------------------#
# select_cards functions
#------------------------------------------------------------------------------#
# TODO: Make AI decision here
func select_cards_easy(cards: Array, qty: int, _select_type: int) -> Array:
	"""
	Method: select_cards_easy
	
	Method to select a card for a bot with an ``easy`` level of difficulty.
	
	:param Array cards: Array of cards to choose from.
	:param int qty: Quantity of cards to choose.
	:return Array: An array containing the selected cards index.
	"""
	var selection : Array = []
	var index: int
	var cards_copy = cards.duplicate()
	for _i in range(qty):
		index = randi() % cards_copy.size()
		selection.push_back(index)
		cards_copy.remove(index)
	return selection

# TODO: Make AI decision here
func select_cards_medium(cards: Array, qty: int, select_type: int) -> Array:
	"""
	Method: select_cards_medium
	
	Method to select a card for a bot with a ``medium`` level of difficulty.
	
	:param Array cards: Array of cards to choose from.
	:param int qty: Quantity of cards to choose.
	:return Array: An array containing the selected cards index.
	"""
	return select_cards_easy(cards, qty, select_type)

# TODO: Make AI decision here
func select_cards_hard(cards: Array, qty: int, select_type: int) -> Array:
	"""
	Method: select_cards_hard
	
	Method to select a card for a bot with a ``hard`` level of difficulty.
	
	:param Array cards: Array of cards to choose from.
	:param int qty: Quantity of cards to choose.
	:return Array: An array containing the selected cards index.
	"""
	return select_cards_easy(cards, qty, select_type)

#------------------------------------------------------------------------------#
# branch_options functions
#------------------------------------------------------------------------------#
# TODO: Make AI decision here
func branch_options_easy(options: Array, _card_type: int) -> int:
	"""
	Method: branch_options_easy
	
	Method to select an option for a bot with an ``easy`` level of difficulty.
	
	:param Array options: Array of cards to choose from.
	:return int: The selected option index.
	"""
	return options[randi() % options.size()]

# TODO: Make AI decision here
func branch_options_medium(options: Array, card_type: int) -> int:
	"""
	Method: branch_options_medium
	
	Method to select an option for a bot with a ``medium`` level of difficulty.
	
	:param Array options: Array of cards to choose from.
	:return int: The selected option index.
	"""
	return branch_options_easy(options, card_type)

# TODO: Make AI decision here
func branch_options_hard(options: Array, card_type: int) -> int:
	"""
	Method: branch_options_hard
	
	Method to select an option for a bot with a ``hard`` level of difficulty.
	
	:param Array options: Array of cards to choose from.
	:return int: The selected option index.
	"""
	return branch_options_easy(options, card_type)

#------------------------------------------------------------------------------#
# request_kill_card functions
#------------------------------------------------------------------------------#
# TODO: Make AI decision here
func request_kill_card_easy(cards: Array, qty: int) -> Array:
	"""
	Method: request_kill_card_easy
	
	Method to select <qty> cards to kill for a bot with an ``easy`` level of difficulty.
	
	:param Array cards: Array of cards to choose from.
	:param int qty: Quantity of cards to choose.
	:return Array: An array containing the selected cards index.
	"""
	var index: int
	var selection : Array = []
	var cards_copy = cards.duplicate()
	for _i in range(qty):
		index = randi() % cards_copy.size()
		selection.push_back(index)
		cards_copy.remove(index)
	return selection

# TODO: Make AI decision here
func request_kill_card_medium(cards: Array, qty: int) -> Array:
	"""
	Method: request_kill_card_medium
	
	Method to select <qty> cards to kill for a bot with an ``medium`` level of difficulty.
	
	:param Array cards: Array of cards to choose from.
	:param int qty: Quantity of cards to choose.
	:return Array: An array containing the selected cards index.
	"""
	return request_kill_card_easy(cards, qty)

# TODO: Make AI decision here
func request_kill_card_hard(cards: Array, qty: int) -> Array:
	"""
	Method: request_kill_card_hard
	
	Method to select <qty> cards to kill for a bot with a ``hard`` level of difficulty.
	
	:param Array cards: Array of cards to choose from.
	:param int qty: Quantity of cards to choose.
	:return Array: An array containing the selected cards index.
	"""
	return request_kill_card_easy(cards, qty)

#------------------------------------------------------------------------------#
# _on_start_reaction functions
#------------------------------------------------------------------------------#
# TODO: Make AI decision here
func _on_start_reaction_easy(calling_action: Action) -> void:
	"""
	Method: _on_start_reaction_easy
	
	Method to make a reaction to the **calling_action** for a bot with an ``easy`` level of difficulty.
	
	:param Action calling_action: The action to react to.
	:return void: The return is made by affecting a new {Action} to the ``_action`` property.
	"""
	if (randi() % 100) < 50:
		if calling_action._can_be_countered:
			var counters: Array = Action.get_counters(calling_action.get_action_type())
			# Select a random counter
			var rand_index: int = randi() % counters.size()
			var counter_id: int = counters[rand_index]
			# Makes sure the counter is in _roles array (is allowed)
			while !(counter_id in _roles):
				rand_index = (rand_index + 1) % counters.size()
				counter_id = counters[rand_index]
			_action = Action.new(Action.ACTION_TYPE.COUNTER, get_id(), [calling_action.get_sender_id()], counter_id)
		elif calling_action._can_be_doubted:
			_action = Action.new(Action.ACTION_TYPE.DOUBT, get_id(), [calling_action.get_sender_id()])
	else:
		_action = Action.new(Action.ACTION_TYPE.PASS, get_id(), [0])
	emit_signal("player_reaction", _action)

# TODO: Make AI decision here
func _on_start_reaction_medium(calling_action: Action) -> void:
	"""
	Method: _on_start_reaction_medium
	
	Method to make a reaction to the **calling_action** for a bot with a ``medium`` level of difficulty.
	
	:param Action calling_action: The action to react to.
	:return void: The return is made by affecting a new {Action} to the ``_action`` property.
	"""
	_on_start_reaction_easy(calling_action)

# TODO: Make AI decision here
func _on_start_reaction_hard(calling_action: Action) -> void:
	"""
	Method: _on_start_reaction_hard
	
	Method to make a reaction to the **calling_action** for a bot with an ``hard`` level of difficulty.
	
	:param Action calling_action: The action to react to.
	:return void: The return is made by affecting a new {Action} to the ``_action`` property.
	"""
	_on_start_reaction_easy(calling_action)


static func get_difficulty_str(difficulty: int) -> String:
	var difficulty_str = ""
	match difficulty:
		BOT_DIFFICULTY.EASY:
			difficulty_str = "EASY"
		BOT_DIFFICULTY.MEDIUM:
			difficulty_str = "MEDIUM"
		BOT_DIFFICULTY.HARD:
			difficulty_str = "HARD"
		_:
			pass
	return difficulty_str
