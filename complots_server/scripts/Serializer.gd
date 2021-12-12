extends Node

class_name Serializer



func _init():
	pass # Replace with function body.

static func card_to_dic(card: Card)-> Dictionary:
	if card == null:
		return {}
	var data: Dictionary = {}
	data["type"] = card._type
	data["counter"] = card._counters # Elements of type: Action.ACTION_TYPE
	data["is_dead"] = card._is_dead
	data["is_selected"] = card._is_selected
	return data

static func dic_to_card(data: Dictionary)-> Card:
	if data.size() == 0:
		return null
	var card = Card.new(data["type"])
	card._counters = data["counter"]  # Elements of type: Action.ACTION_TYPE
	card._is_dead = data["is_dead"]
	card._is_selected = data["is_selected"]
	return card

static func player_to_dic(player: Player_Base):
	if player == null:
		return {}
	var data: Dictionary = {}
	data["id"] = player._id
	data["username"] = player._username
	data["balance"] = player._balance
	data["hand"] = {}
	for i in player._hand.size():
		data["hand"][i] = card_to_dic(player._hand[i])
	data["action"] = action_to_dic(player._action)
	data["color"] = player._color
	data["passed"] = player._passed
	data["roles"] = player._roles
	return data


static func dic_to_player(data: Dictionary):
	if data.size() == 0:
		return null
	var player = Player_Base.new(data["id"],data["username"],data["color"],data["roles"])
	for i in data["hand"]:
		player._hand.append(dic_to_card(data["hand"][i])) 
	player._balance = data["balance"]
	player._action = dic_to_action(data["action"])
	player._passed = data["passed"]
	return player
	
static func action_to_dic(action: Action):
	if action == null:
		return {}
	var data: Dictionary = {}
	data["action_type"] = action._action_type
	data["sender_id"] = action._sender_id
	data["target_id"] = action._targets_id
	data["card_type"] = action._card_type
	data["cost"] = action._cost
	return data
	
static func dic_to_action(data: Dictionary):
	if data.size() == 0:
		return null
	var action = Action.new(data["action_type"],data["sender_id"],data["target_id"],data["card_type"])
	action._cost = data["cost"]
	return action
	
