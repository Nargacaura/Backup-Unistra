extends "res://addons/gut/test.gd"

################################################################################
# Class : TestCardConstructor
class TestCardConstructor:
	extends "res://addons/gut/test.gd"
	
	var Card = load("res://scripts/core/Card.gd")
	var _card = null
	
	func before_each():
		pass
	
	func after_each():
		pass
	
	func before_all():
		pass
	
	func after_all():
		pass
	
	func test_empty_constructor():
		_card = Card.new()
		assert_is(_card, Card)
		assert_eq(_card.get_type(), Card.CARD_TYPE.INVALID)
		assert_eq(_card.is_dead(), false)
		assert_eq(_card.is_selected(), false)
		assert_eq(_card.get_counters(), [])
	
	func test_good_constructors():
		# Enum
		_test_constructor(Card.CARD_TYPE.HIDDEN, Card.CARD_TYPE.HIDDEN, [])
		_test_constructor(Card.CARD_TYPE.DUKE, Card.CARD_TYPE.DUKE, [Action.ACTION_TYPE.FOREIGN_AID])
		_test_constructor(Card.CARD_TYPE.ASSASSIN, Card.CARD_TYPE.ASSASSIN, [])
		_test_constructor(Card.CARD_TYPE.CONTESSA, Card.CARD_TYPE.CONTESSA, [Action.ACTION_TYPE.ASSASSIN])
		_test_constructor(Card.CARD_TYPE.CAPTAIN, Card.CARD_TYPE.CAPTAIN, [Action.ACTION_TYPE.CAPTAIN])
		_test_constructor(Card.CARD_TYPE.AMBASSADOR, Card.CARD_TYPE.AMBASSADOR, [Action.ACTION_TYPE.CAPTAIN])
		_test_constructor(Card.CARD_TYPE.INQUISITOR, Card.CARD_TYPE.INQUISITOR, [Action.ACTION_TYPE.CAPTAIN])
		# Numbers
		_test_constructor(0, Card.CARD_TYPE.HIDDEN, [])
		_test_constructor(1, Card.CARD_TYPE.DUKE, [Action.ACTION_TYPE.FOREIGN_AID])
		_test_constructor(2, Card.CARD_TYPE.ASSASSIN, [])
		_test_constructor(3, Card.CARD_TYPE.CONTESSA, [Action.ACTION_TYPE.ASSASSIN])
		_test_constructor(4, Card.CARD_TYPE.CAPTAIN, [Action.ACTION_TYPE.CAPTAIN])
		_test_constructor(5, Card.CARD_TYPE.AMBASSADOR, [Action.ACTION_TYPE.CAPTAIN])
		_test_constructor(6, Card.CARD_TYPE.INQUISITOR, [Action.ACTION_TYPE.CAPTAIN])
	
	func test_bad_constructors():
		_test_constructor(-1, Card.CARD_TYPE.INVALID, [])
		_test_constructor(50, Card.CARD_TYPE.INVALID, [])
	
	func _test_constructor(_input, _type: int, _counters: Array):
		_card = Card.new(_input)
		assert_is(_card, Card)
		assert_eq(_card.get_type(), _type)
		assert_eq(_card.is_dead(), false)
		assert_eq(_card.is_selected(), false)
		assert_eq(_card.get_counters(), _counters)
		_card = null
	

################################################################################
# Class : TestNames
class TestCardNames:
	extends "res://addons/gut/test.gd"
	
	var Card = load("res://scripts/core/Card.gd")
	var _card = null
	
	func before_each():
		pass
	
	func after_each():
		pass
	
	func before_all():
		pass
	
	func after_all():
		pass
	
	func test_all_names():
		# List of names
		var _names = [
		"Hidden",
		"Duke",
		"Assassin",
		"Contessa",
		"Captain",
		"Ambassador",
		"Inquisitor",
		"Invalid Name"
		]
		# Testing all names + 9 more invalid input
		for _type in range(Card.CARD_TYPE.HIDDEN, Card.CARD_TYPE.INVALID + 10):
			_test_name(_type, _names[_type if _type < _names.size() - 1 else _names.size() - 1])
	
	func _test_name(_type: int, _name: String):
		_card = Card.new(_type)
		assert_eq(_card.get_name(), _name)
		_card = null
	
