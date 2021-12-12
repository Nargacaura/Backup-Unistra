class_name Action

################################################################################
#                                 ENUMERATIONS                                 #
################################################################################
enum ACTION_TYPE {
	START,
	END,
	PASS,
	# Basic Actions
	DOUBT,
	COUNTER,
	INCOME,
	FOREIGN_AID,
	COUP,
	# COMPLOTS Character Actions
	DUKE,
	ASSASSIN,
	CONTESSA,
	CAPTAIN,
	AMBASSADOR,
	INQUISITOR_1,
	INQUISITOR_2,
}
"""
Enum: ACTION_TYPE

Enumeration to store action types in a human readable way.

:param START: The first action on the action stack.
:param END: The last action on the action stack.
:param PASS: When a player decide to pass in the reaction phase.
:param DOUBT: A player doubts another player's action.
:param COUNTER: A player counters another player's action.
:param INCOME: Basic action, takes one coin to the Court.
:param FOREIGN_AID: Takes two coins to the Court.
:param COUP: Kill a player card for the price of 7 coins.
:param DUKE: Takes three coins to the Court.
:param ASSASSIN: Kill a player card for the price of 3 coins.
:param CONTESSA: Should not be on the action stack.
:param CAPTAIN: Takes two coins to a player.
:param AMBASSADOR: Switch two of the alive player cards.
:param INQUISITOR_1: Switch one of the alive player cards.
:param INQUISITOR_2: Look at one card of a given player, choose to leave it in their hand or send it back to the Court.
"""

enum SELECT_TYPE {
	KILL,
	SHOW,
	KEEP,
	RETURN_TO_COURT,
}

################################################################################
#                                  ATTRIBUTES                                  #
################################################################################
var _action_type: int
"""The type of action."""

var _sender_id: int
"""ID of the player that made the action."""

var _targets_id: Array
"""Array containing the ID of the players targeted by the action."""

var _cost: int
"""The cost of the action."""

var _can_be_countered: bool
"""If the action can be countered."""

var _can_be_doubted: bool
"""If the action can be doubted."""

var _card_type: int
"""The card type that made the action"""

const ACTION_SHORT_TIMEOUT: int = 2
"""Time to wait after a short action is made."""

const ACTION_TIMEOUT: int = 30
"""Time to let the players react to a *long* action."""

################################################################################
# Constructor
func _init(action_type: int, sender_id: int, targets_id: Array, card_type: int = 0):
	_action_type = action_type
	_sender_id = sender_id
	_targets_id = targets_id
	_cost = _calculate_action_cost()
	_can_be_countered = _can_action_be_countered()
	_can_be_doubted = _can_action_be_doubted()
	_card_type = card_type

################################################################################
#                              PRIVATE FUNCTIONS                               #
################################################################################
func _calculate_action_cost() -> int:
	"""
	Method: _calculate_action_cost
	
	Method called in the constructor to return the action cost.
	
	:return int: Action's cost.
	"""
	var cost: int = 0
	match _action_type:
		ACTION_TYPE.COUP: cost = 7
		ACTION_TYPE.ASSASSIN: cost = 3
		_: cost = 0
	return cost

func _can_action_be_countered() -> bool:
	"""
	Method: _can_action_be_countered
	
	Method called in the constructor to return a boolean that tells if the action can be countered.
	
	:return bool: Boolean that tells if the action can be countered.
	"""
	var counter: bool = false
	match _action_type:
		ACTION_TYPE.FOREIGN_AID: counter = true
		ACTION_TYPE.CAPTAIN: counter = true
		ACTION_TYPE.ASSASSIN: counter = true
		_: counter = false
	return counter

func _can_action_be_doubted() -> bool:
	"""
	Method: _can_action_be_doubted
	
	Method called in the constructor to return a boolean that tells if the action can be doubted.
	
	:return bool: Boolean that tells if the action can be doubted.
	"""
	var doubt: bool = true
	match _action_type:
		ACTION_TYPE.START: doubt = false
		ACTION_TYPE.END: doubt = false
		ACTION_TYPE.DOUBT: doubt = false
		ACTION_TYPE.INCOME: doubt = false
		ACTION_TYPE.FOREIGN_AID: doubt = false
		ACTION_TYPE.COUP: doubt = false
		_: doubt = true
	return doubt

################################################################################
#                                   GETTERS                                    #
################################################################################
func get_action_type() -> int:
	return _action_type

func get_sender_id() -> int:
	return _sender_id

func get_targets_id() -> Array:
	return _targets_id

func get_cost() -> int:
	return _cost

func get_card_type() -> int:
	return _card_type

func can_be_countered() -> bool:
	return _can_be_countered

################################################################################
#                               STATIC FUNCTIONS                               #
################################################################################
static func get_action_string(action_type: int) -> String:
	"""
	Static Method: get_action_string
	
	Static Method to get the short description of the action.
	
	:param int action_type: Type of the action.
	:return String: Returns the short description of the action.
	"""
	var s = ""
	match action_type:
		ACTION_TYPE.DOUBT: s = "Doubt"
		ACTION_TYPE.COUNTER: s = "Counter"
		ACTION_TYPE.INCOME: s = "Income"
		ACTION_TYPE.FOREIGN_AID: s = "Foreign Aid"
		ACTION_TYPE.COUP: s = "Coup"
		ACTION_TYPE.DUKE: s = "Take 3 coins"
		ACTION_TYPE.ASSASSIN: s = "Kill someone"
		ACTION_TYPE.CONTESSA: s = ""
		ACTION_TYPE.CAPTAIN: s = "Take 2 coins to someone"
		ACTION_TYPE.AMBASSADOR: s = "Exchange 2 cards"
		ACTION_TYPE.INQUISITOR_1: s = "Exchange 1 card"
		ACTION_TYPE.INQUISITOR_2: s = "Look at one card"
		_: s = "Invalid Action"
	return s


static func get_localized_key(action_type: int) -> String:
	"""
	Static Method: get_localized_key
	
	Static Method to get the localized key.
	
	:param int action_type: Type of the action.
	:return String: Returns the localized key.
	"""
	var s = ""
	match action_type:
		ACTION_TYPE.DOUBT: s = "action.doubt"
		ACTION_TYPE.COUNTER: s = "action.counter"
		ACTION_TYPE.INCOME: s = "action.income"
		ACTION_TYPE.FOREIGN_AID: s = "action.foreign_aid"
		ACTION_TYPE.COUP: s = "action.coup"
		ACTION_TYPE.DUKE: s = "action.duke"
		ACTION_TYPE.ASSASSIN: s = "action.assassin"
		ACTION_TYPE.CONTESSA: s = ""
		ACTION_TYPE.CAPTAIN: s = "action.captain"
		ACTION_TYPE.AMBASSADOR: s = "action.ambassador"
		ACTION_TYPE.INQUISITOR_1: s = "action.inquisitor_1"
		ACTION_TYPE.INQUISITOR_2: s = "action.inquisitor_2"
		_: s = "Invalid Action"
	return s


static func get_counters(action_type: int) -> Array:
	"""
	Static Method: get_counters
	
	Static Method to get the counters of the action.
	
	:param int action_type: Type of the action.
	:return String: Returns the counters of the action.
	"""
	var Card = load("res://scripts/core/Card.gd")
	var counters: Array = []
	match action_type:
		ACTION_TYPE.FOREIGN_AID: counters = [Card.CARD_TYPE.DUKE]
		ACTION_TYPE.ASSASSIN: counters = [Card.CARD_TYPE.CONTESSA]
		ACTION_TYPE.CAPTAIN: counters = [Card.CARD_TYPE.CAPTAIN, Card.CARD_TYPE.AMBASSADOR, Card.CARD_TYPE.INQUISITOR]
		_: counters = []
	return counters

static func is_main_action(action: Action) -> bool:
	"""
	Static Method: is_main_action
	
	Static Method that checks if the action is a main action.
	
	:param Action action: Action to check.
	:return String: Returns ``true`` if the action is a main action else ``false``.
	"""
	var is_main: bool = false
	match action.get_action_type():
		ACTION_TYPE.START,\
		ACTION_TYPE.END,\
		ACTION_TYPE.PASS,\
		ACTION_TYPE.DOUBT,\
		ACTION_TYPE.COUNTER:
			is_main = false
		_:
			is_main = true
	return is_main

static func is_reaction(action: Action) -> bool:
	"""
	Static Method: is_reaction
	
	Static Method that checks if the action is a reaction.
	
	:param Action action: Action to check.
	:return String: Returns ``true`` if the action is a reaction else ``false``.
	"""
	var result: bool = false
	match action.get_action_type():
		ACTION_TYPE.DOUBT,\
		ACTION_TYPE.COUNTER:
			result = true
		_:
			result = false
	return result


static func need_target(action_type: int) -> bool:
	"""
	Static Method: need_target
	
	Static Method that checks if the action need a target.
	
	:param Action action: Action to check.
	:return String: Returns ``true`` if the action need a target else ``false``.
	"""
	var need: bool = false
	match action_type:
		ACTION_TYPE.COUP,\
		ACTION_TYPE.ASSASSIN,\
		ACTION_TYPE.CAPTAIN,\
		ACTION_TYPE.INQUISITOR_2:
			need = true
		_:
			need = false
	return need
