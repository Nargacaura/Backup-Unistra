class_name Card

################################################################################
#                                 ENUMERATIONS                                 #
################################################################################
enum CARD_TYPE {
	HIDDEN = 0,
	DUKE,
	ASSASSIN,
	CONTESSA,
	CAPTAIN,
	AMBASSADOR,
	INQUISITOR,
	INVALID
}
"""
Enum: CARD_TYPE

Enumeration to store card types in a human readable way.

:param HIDDEN: Card type for opponents cards that are not dead.
:param DUKE: Duke character.
:param ASSASSIN: Assassin character.
:param CONTESSA: Contessa character.
:param CAPTAIN: Captain character.
:param AMBASSADOR: Ambassador character.
:param INQUISITOR: Inquisitor character.
:param INVALID: Card type for invalid cards.
"""

################################################################################
#                                  ATTRIBUTES                                  #
################################################################################
var _type: int
"""The type of card."""

var _counters: Array # Elements of type: Action.ACTION_TYPE
"""Array of counters, elements are of type **Action.ACTION_TYPE**."""

var _is_dead: bool
"""Boolean: ``true`` if the card is dead else ``false``."""

var _is_selected: bool
"""Boolean: ``true`` if the card is selected else ``false``."""

################################################################################
# Constructor
# Class : Card
# Default value :
#     type = CARD_TYPE.INVALID : By default invalid card type
func _init(type: int = CARD_TYPE.INVALID):
	if type > CARD_TYPE.INVALID || type < CARD_TYPE.HIDDEN:
		_type = CARD_TYPE.INVALID
	else:
		_type = type
	_is_dead = false
	_is_selected = false
	_set_default_counter()

################################################################################
#                               PUBLIC FUNCTIONS                               #
################################################################################
func get_name() -> String:
	"""
	Method: get_name
	
	Method to get the name of the card.
	
	:return String: Returns the name of the card.
	"""
	var name: String = ""
	match _type:
		CARD_TYPE.HIDDEN: name = "?"
		CARD_TYPE.DUKE: name = "Duke"
		CARD_TYPE.ASSASSIN: name = "Assassin"
		CARD_TYPE.CONTESSA: name = "Contessa"
		CARD_TYPE.CAPTAIN: name = "Captain"
		CARD_TYPE.AMBASSADOR: name = "Ambassador"
		CARD_TYPE.INQUISITOR: name = "Inquisitor"
		_: name = "Invalid Name"
	return name

func kill() -> void:
	"""
	Method: kill
	
	Method to kill the card (set _is_dead to ``true``).
	
	:return void:
	"""
	_is_dead = true

################################################################################
#                              PRIVATE FUNCTIONS                               #
################################################################################
func _set_default_counter() -> void:
	"""
	Method: _set_default_counter
	
	Method called in the constructor to set the default counters.
	
	:return void:
	"""
	match _type:
		CARD_TYPE.DUKE: _counters = [Action.ACTION_TYPE.FOREIGN_AID]
		CARD_TYPE.CONTESSA: _counters = [Action.ACTION_TYPE.ASSASSIN]
		CARD_TYPE.CAPTAIN: _counters = [Action.ACTION_TYPE.CAPTAIN]
		CARD_TYPE.AMBASSADOR: _counters = [Action.ACTION_TYPE.CAPTAIN]
		CARD_TYPE.INQUISITOR: _counters = [Action.ACTION_TYPE.CAPTAIN]
		_: _counters = []

################################################################################
#                                   GETTERS                                    #
################################################################################
func get_type() -> int:
	return _type

func get_counters() -> Array:
	return _counters

func get_counter(_index: int) -> Array:
	return _counters[_index]

func is_dead() -> bool:
	return _is_dead

func is_selected() -> bool:
	return _is_selected

################################################################################
#                               STATIC FUNCTIONS                               #
################################################################################
static func get_card_name(type: int) -> String:
	"""
	Static Method: get_card_name
	
	Static Method to get the name of a card by its card_type.
	
	:param int type: Type of the card.
	:return String: Returns the name of the card.
	"""
	var name: String = ""
	match type:
		CARD_TYPE.HIDDEN: name = "Hidden"
		CARD_TYPE.DUKE: name = "Duke"
		CARD_TYPE.ASSASSIN: name = "Assassin"
		CARD_TYPE.CONTESSA: name = "Contessa"
		CARD_TYPE.CAPTAIN: name = "Captain"
		CARD_TYPE.AMBASSADOR: name = "Ambassador"
		CARD_TYPE.INQUISITOR: name = "Inquisitor"
		_: name = "Invalid Card Name"
	return name
