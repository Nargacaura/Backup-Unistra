extends "res://addons/gut/test.gd"

################################################################################
# Class : TestActionConstructor
class TestActionConstructor:
	extends "res://addons/gut/test.gd"
	
	var Action = load("res://scripts/core/Action.gd")
	var _action = null
	
	func before_each():
		pass
	
	func after_each():
		pass
	
	func before_all():
		pass
	
	func after_all():
		pass
		
	func test_good_constructors():
		_test_constructor(Action.ACTION_TYPE.END, 0, [])
		_test_constructor(Action.ACTION_TYPE.DUKE, 1, [])
		_test_constructor(Action.ACTION_TYPE.ASSASSIN, 2, [1])
		_test_constructor(Action.ACTION_TYPE.CONTESSA, 3, [3])
		_test_constructor(Action.ACTION_TYPE.CAPTAIN, 4, [2])
		_test_constructor(Action.ACTION_TYPE.INQUISITOR_2, 5, [4])
		
	func test_bad_constructors():
		# Wrong type of Action
		_test_constructor(-1, 0, [])
		# Inappropriate Sender id 
		_test_constructor(Action.ACTION_TYPE.DUKE, -2, [])
		# Assassin can not select himself
		_test_constructor(Action.ACTION_TYPE.ASSASSIN, 2, [2])
		# Too many targets
		_test_constructor(Action.ACTION_TYPE.DOUBT, 2, [2, 4, 5])
		_test_constructor(Action.ACTION_TYPE.COUNTER, 2, [2, 4, 5])
		_test_constructor(Action.ACTION_TYPE.ASSASSIN, 2, [2, 4, 5])
		# Can not has a target
		_test_constructor(Action.ACTION_TYPE.INCOME, 0, [3])
		_test_constructor(Action.ACTION_TYPE.COUP, 0, [4])

	func _test_constructor(_action_type: int, _sender_id: int, _targets_id: Array):
		_action = Action.new(_action_type, _sender_id, _targets_id)
		assert_is(_action, Action)
		assert_eq(_action.get_action_type(), _action_type)
		assert_eq(_action.get_sender_id(), _sender_id)
		assert_eq(_action.get_targets_id(), _targets_id)
		_action = null


################################################################################
# Class : TestActionFunctions
class TestActionFunctions:
	extends "res://addons/gut/test.gd"
	
	var Action = load("res://scripts/core/Action.gd")
	
	func before_each():
		pass
			
	func after_each():
		var _action = null
		
	func before_all():
		pass
	
	func after_all():
		pass
		
	func test_calculate_action_cost():
		var _action = Action.new(Action.ACTION_TYPE.COUP, 1, [])
		assert_true(_action._calculate_action_cost() == 7)
		assert_false(_action._calculate_action_cost() == -3 )
		_action = Action.new(Action.ACTION_TYPE.INCOME, 1, [])
		assert_true(_action._calculate_action_cost() < 1 )
		assert_false(_action._calculate_action_cost() > 5 )
		_action = Action.new(Action.ACTION_TYPE.ASSASSIN, 1, [])
		assert_true(_action._calculate_action_cost() == 3)
		assert_false(_action._calculate_action_cost() < -7)
		_action = Action.new(Action.ACTION_TYPE.DOUBT, 1, [])
		assert_true(_action._calculate_action_cost() > -1)
		assert_false(_action._calculate_action_cost() < -2 )
		
	func test_can_action_be_countered():
		var _action = Action.new(Action.ACTION_TYPE.COUP, 1, [])
		assert_false(_action._can_action_be_countered())
		_action = Action.new(Action.ACTION_TYPE.INCOME, 1, [])
		assert_false(_action._can_action_be_countered())
		_action = Action.new(Action.ACTION_TYPE.END, 1, [])
		assert_false(_action._can_action_be_countered())
		_action = Action.new(Action.ACTION_TYPE.DOUBT, 1, [])
		assert_false(_action._can_action_be_countered())
		_action = Action.new(Action.ACTION_TYPE.COUNTER, 1, [])
		assert_false(_action._can_action_be_countered())
		_action = Action.new(Action.ACTION_TYPE.FOREIGN_AID, 1, [])
		assert_true(_action._can_action_be_countered())
		_action = Action.new(Action.ACTION_TYPE.ASSASSIN, 1, [])
		assert_true(_action._can_action_be_countered())
		_action = Action.new(Action.ACTION_TYPE.CAPTAIN, 1, [])
		assert_true(_action._can_action_be_countered())
	
func test_can_action_be_doubted():
		var _action = Action.new(Action.ACTION_TYPE.COUP, 1, [])
		assert_false(_action._can_action_be_doubted())
		_action = Action.new(Action.ACTION_TYPE.INCOME, 1, [])
		assert_false(_action._can_action_be_doubted())
		_action = Action.new(Action.ACTION_TYPE.END, 1, [])
		assert_false(_action._can_action_be_doubted())
		_action = Action.new(Action.ACTION_TYPE.DOUBT, 1, [])
		assert_false(_action._can_action_be_doubted())
		_action = Action.new(Action.ACTION_TYPE.ASSASSIN, 1, [])
		assert_true(_action._can_action_be_doubted())
		_action = Action.new(Action.ACTION_TYPE.CAPTAIN, 1, [])
		assert_true(_action._can_action_be_doubted())
		_action = Action.new(Action.ACTION_TYPE.DUKE, 1, [])
		assert_true(_action._can_action_be_doubted())
		_action = Action.new(Action.ACTION_TYPE.AMBASSADOR, 1, [])
		assert_true(_action._can_action_be_doubted())

func test_get_action_string():
		assert_eq("Kill someone",Action.get_action_string(Action.ACTION_TYPE.ASSASSIN))
		assert_ne("Exchange 1 card",Action.get_action_string(Action.ACTION_TYPE.AMBASSADOR))
		assert_ne("Take 4 coins",Action.get_action_string(Action.ACTION_TYPE.DUKE))
		assert_eq("",Action.get_action_string(Action.ACTION_TYPE.CONTESSA))
		assert_ne("Take 2 coins from tresor",Action.get_action_string(Action.ACTION_TYPE.CAPTAIN))
		assert_eq("Coup",Action.get_action_string(Action.ACTION_TYPE.COUP))
		
func test_get_counters():
		assert_eq(Action.get_counters(Action.ACTION_TYPE.FOREIGN_AID), [Card.CARD_TYPE.DUKE])
		assert_ne(Action.get_counters(Action.ACTION_TYPE.ASSASSIN), [Card.CARD_TYPE.ASSASSIN])
		assert_eq(Action.get_counters(Action.ACTION_TYPE.CAPTAIN), \
			[Card.CARD_TYPE.CAPTAIN, Card.CARD_TYPE.AMBASSADOR, Card.CARD_TYPE.INQUISITOR]) 
		assert_eq(Action.get_counters(Action.ACTION_TYPE.DOUBT), [])



