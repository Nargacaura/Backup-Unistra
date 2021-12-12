extends HBoxContainer

const Card_Scene = preload("res://scenes/Card_Test.tscn")

signal choose_action(action_type, targets_id, card_type)
#signal select_targets(action_type)
signal targets_confirmed(targets)
signal targets_validated(targets)
signal choose_cards(cards)
signal choose_options(option)
signal reaction(action_type, calling_action, card_type)
signal hand_updated()

var _id: int = 0
var _alive_card: int = 2
var _action_container: Node = null
var _target_container: Node = null
var _card_select_container: Node = null
var _card_array: Array = []
var _timer: Timer = null
var _players_data: Dictionary

func _ready():
	_timer = Timer.new()
	add_child(_timer)
	_action_container.hide()
	_action_container.set_process(false)
	_target_container.hide()
	_target_container.set_process(false)
	_card_select_container.hide()
	_card_select_container.set_process(false)
	
func _on_init_player(player: Player_Base):
	$Player_Badge/Info/Username.set_text(player.get_username())

func _on_change_balance(balance: int):
	$Player_Badge/Info/Coins.set_text("Coins: " + str(balance))

func _on_add_card(card: Card):
	if card == null:
		return
	var card_scene = Card_Scene.instance()
	card_scene.get_child(0).set_text(card.get_name())
	$Cards.add_child(card_scene)
	emit_signal("hand_updated")

func _on_remove_card(card_id: int) -> void:
	var card = $Cards.get_child(card_id)
	if typeof(card) == TYPE_NIL:
		print("card %d not found" % [card_id])
	else:
		print("card %d found" % [card_id])
		$Cards.get_child(card_id).free()
	emit_signal("hand_updated")

func _on_choose_cards(cards: Array, qty: int, text: String) -> void:
	_action_container.hide()
	_action_container.set_process(false)
	_target_container.hide()
	_target_container.set_process(false)
	_card_select_container.get_child(0).set_text(text)
	for child in _card_select_container.get_child(1).get_children():
		child.free()
	for i in range(0,cards.size()):
		_create_select_button(cards[i].get_name(), i, _card_select_container.get_child(1), "_on_card_pressed", [i,qty])
		if cards[i].is_dead():
			_card_select_container.get_child(1).get_child(i).set_disabled(true)
	if _card_select_container.get_child(2).is_pressed():
		_card_select_container.get_child(2).set_pressed(false)
	if _card_select_container.get_child(2).is_connected("pressed", self, "_on_Cards_Confirm_pressed"):
		_card_select_container.get_child(2).disconnect("pressed", self, "_on_Cards_Confirm_pressed")
	var _s = _card_select_container.get_child(2).connect("pressed", self, "_on_Cards_Confirm_pressed")
	_card_select_container.show()
	_card_select_container.set_process(true)

func _on_Cards_Confirm_pressed() -> void:
	var select: Array = []
	var children: Array = _card_select_container.get_child(1).get_children()
	for i in range(0,children.size()):
		if children[i].is_pressed():
			select.push_back(i)
	_card_select_container.hide()
	_card_select_container.set_process(false)
	#_card_select_container.get_child(2).disconnect("pressed", self, "_on_Cards_Confirm_pressed")
	emit_signal("choose_cards", select)

func _on_play_turn(player: Player_Base, roles: Array, players_data: Dictionary) -> void:
	_players_data = players_data
	var actions: Array = player.get_actions()
	if player.get_balance() >= 7:
		_create_button(Action.get_action_string(Action.ACTION_TYPE.COUP), Action.ACTION_TYPE.COUP)
		if player.get_balance() >= 10:
			var label: Label = Label.new()
			label.add_color_override("font_color", Color("#ff0000"))#set_font_color(Color("#ff0000"))
			label.set_autowrap(true)
			label.text = "Vous avez amassé plus de 10 Or. Il est temps de passer à l'acte !"
			label.set_v_size_flags(SIZE_FILL | SIZE_EXPAND)
			_action_container.get_child(1).get_child(1).add_child(label)
			_action_container.show()
			_action_container.set_process(true)
			return
	_create_button(Action.get_action_string(Action.ACTION_TYPE.INCOME), Action.ACTION_TYPE.INCOME)
	_create_button(Action.get_action_string(Action.ACTION_TYPE.FOREIGN_AID), Action.ACTION_TYPE.FOREIGN_AID)
	var i: int = 1
	var first_action: int = 0
	for action in actions:
		if i == 2:
			first_action = actions[0]
		if first_action != 0 and action == first_action:
			continue
		match action:
			Card.CARD_TYPE.DUKE:
				_create_button(Action.get_action_string(Action.ACTION_TYPE.DUKE), Action.ACTION_TYPE.DUKE, Card.CARD_TYPE.DUKE)
			Card.CARD_TYPE.ASSASSIN:
				if player.get_balance() >= 3:
					_create_button(Action.get_action_string(Action.ACTION_TYPE.ASSASSIN), Action.ACTION_TYPE.ASSASSIN, Card.CARD_TYPE.ASSASSIN)
			Card.CARD_TYPE.CAPTAIN:
				_create_button(Action.get_action_string(Action.ACTION_TYPE.CAPTAIN), Action.ACTION_TYPE.CAPTAIN, Card.CARD_TYPE.CAPTAIN)
			Card.CARD_TYPE.AMBASSADOR:
				_create_button(Action.get_action_string(Action.ACTION_TYPE.AMBASSADOR), Action.ACTION_TYPE.AMBASSADOR, Card.CARD_TYPE.AMBASSADOR)
			Card.CARD_TYPE.INQUISITOR:
				_create_button(Action.get_action_string(Action.ACTION_TYPE.INQUISITOR_1), Action.ACTION_TYPE.INQUISITOR_1, Card.CARD_TYPE.INQUISITOR)
				_create_button(Action.get_action_string(Action.ACTION_TYPE.INQUISITOR_2), Action.ACTION_TYPE.INQUISITOR_2, Card.CARD_TYPE.INQUISITOR)
		i += 1
	var bluffs: Array = roles
	var bluff_acts: Array = []
	for role in bluffs:
		bluff_acts.push_back(role)
	for action in bluff_acts:
		if not action in actions:
			match action:
				Card.CARD_TYPE.DUKE:
					_create_button(Action.get_action_string(Action.ACTION_TYPE.DUKE), Action.ACTION_TYPE.DUKE, action, _action_container.get_child(1).get_child(1))
				Card.CARD_TYPE.ASSASSIN:
					if player.get_balance() >= 3:
						_create_button(Action.get_action_string(Action.ACTION_TYPE.ASSASSIN), Action.ACTION_TYPE.ASSASSIN, action, _action_container.get_child(1).get_child(1))
				Card.CARD_TYPE.CAPTAIN:
					_create_button(Action.get_action_string(Action.ACTION_TYPE.CAPTAIN), Action.ACTION_TYPE.CAPTAIN, action, _action_container.get_child(1).get_child(1))
				Card.CARD_TYPE.AMBASSADOR:
					_create_button(Action.get_action_string(Action.ACTION_TYPE.AMBASSADOR), Action.ACTION_TYPE.AMBASSADOR, action, _action_container.get_child(1).get_child(1))
				Card.CARD_TYPE.INQUISITOR:
					_create_button(Action.get_action_string(Action.ACTION_TYPE.INQUISITOR_1), Action.ACTION_TYPE.INQUISITOR_1, action, _action_container.get_child(1).get_child(1))
					_create_button(Action.get_action_string(Action.ACTION_TYPE.INQUISITOR_2), Action.ACTION_TYPE.INQUISITOR_2, action, _action_container.get_child(1).get_child(1))
	_action_container.show()
	_action_container.set_process(true)
	
func select_targets(action_type: int):
	for child in _target_container.get_child(1).get_children():
		child.queue_free()
	var max_targets: int
	var min_targets: int
	var loop: bool = true
	var targets: Array = []
	match action_type:
		Action.ACTION_TYPE.COUP,\
		Action.ACTION_TYPE.ASSASSIN,\
		Action.ACTION_TYPE.CAPTAIN,\
		Action.ACTION_TYPE.INQUISITOR_2:
			max_targets = 1
			min_targets = 1
		_: # Default action
			max_targets = 0
			min_targets = 0
			loop = false
			emit_signal("targets_validated", [])
	var button_id: int = 0
	for player_id in _players_data["alive"].keys():
		if player_id != _id:
			if action_type == Action.ACTION_TYPE.CAPTAIN:
				if _players_data["alive"][player_id]["balance"] > 0:
					_create_select_button("%s" % _players_data["alive"][player_id]["username"], player_id, _target_container.get_child(1), "_on_target_pressed", [button_id, min_targets, max_targets])
					button_id += 1
			else:
				_create_select_button("%s" % _players_data["alive"][player_id]["username"], player_id, _target_container.get_child(1), "_on_target_pressed", [button_id, min_targets, max_targets])
				button_id += 1
	_target_container.get_child(0).text = 'Targets for "%s"' % Action.get_action_string(action_type)
	_target_container.show()
	if !_target_container.get_child(2).is_connected("pressed", self, "_on_Target_Confirm_pressed"):
		var _s = _target_container.get_child(2).connect("pressed", self, "_on_Target_Confirm_pressed")
	var nb_targets: int = targets.size()
	while loop:
		targets = yield(self, "targets_confirmed")
		nb_targets = targets.size()
		if (nb_targets >= min_targets and nb_targets <= max_targets):
			break
	emit_signal("targets_validated", targets)

func _on_choose_options(options : Array, text : String):
	for child in _action_container.get_child(0).get_child(1).get_children():
		child.queue_free()
	for child in _action_container.get_child(1).get_child(1).get_children():
		child.queue_free()
	for i in range(0,options.size()):
		_create_button(options[i], 0, 0, _action_container.get_child(0).get_child(1), "_on_option_pressed", [i])
	var label: Label = Label.new()
	label.set_autowrap(true)
	label.text = text
	label.set_v_size_flags(SIZE_FILL | SIZE_EXPAND)
	_action_container.get_child(1).get_child(1).add_child(label)
	_action_container.show()
	_action_container.set_process(true)
	
func _on_option_pressed(id: int):
	for child in _action_container.get_child(0).get_child(1).get_children():
		child.queue_free()
	for child in _action_container.get_child(1).get_child(1).get_children():
		child.queue_free()
	_action_container.hide()
	_action_container.set_process(false)
	emit_signal("choose_options", [id])

func _on_card_pressed(id: int, qty: int):
	if qty == 1:
		var children: Array = _card_select_container.get_child(1).get_children()
		for i in range(0, children.size()):
			if i != id and children[i].is_pressed():
				children[i].set_pressed(false)

func _on_target_pressed(id: int, min_targets: int, max_targets: int):
	if min_targets == 1 and max_targets == 1:
		var children: Array = _target_container.get_child(1).get_children()
		for i in range(0, children.size()):
			if i != id and children[i].is_pressed():
				children[i].set_pressed(false)

func _on_Target_Confirm_pressed():
	var targets: Array = []
	for child in _target_container.get_child(1).get_children():
		if child.is_pressed():
			targets.push_back(get_player_id_by_name(child.text))
	emit_signal("targets_confirmed", targets)

func get_player_id_by_name(player_name: String) -> int:
	for player_id in _players_data["alive"]:
		if _players_data["alive"][player_id]["username"] == player_name:
			return player_id
	for player_id in _players_data["dead"]:
		if _players_data["alive"][player_id]["username"] == player_name:
			return player_id
	return -1

func _create_select_button(button_name: String = "Invalid Action", index: int = 0, container: Node = _target_container.get_child(1), callback: String = "_on_target_pressed", data: Array = []):
	if data == []:
		data.push_back(index)
	var button: Button = CheckButton.new()
	button.text = button_name
	var _s = button.connect("pressed", self, callback, data)
	button.set_v_size_flags(SIZE_FILL | SIZE_EXPAND)
	container.add_child(button)

func _create_button(button_name: String = "Invalid Action", action_type: int = 0, card_type: int = 0, container: Node = _action_container.get_child(0).get_child(1), callback: String = "_on_action_pressed", data: Array = []):
	if data == []:
		data.push_back(action_type)
		data.push_back(card_type)
	var button: Button = Button.new()
	button.text = button_name
	button.set_h_size_flags(SIZE_EXPAND_FILL)
	var _s = button.connect("pressed", self, callback, data)
	button.set_v_size_flags(SIZE_FILL | SIZE_EXPAND)
	container.add_child(button)

func _on_action_pressed(action_type: int, card_type: int):
	var _targets: Array = []
	if (action_type in [Action.ACTION_TYPE.COUP, Action.ACTION_TYPE.ASSASSIN, Action.ACTION_TYPE.CAPTAIN, Action.ACTION_TYPE.INQUISITOR_2]):
		select_targets(action_type)
		_targets = yield(self, "targets_validated")
	_action_container.hide()
	_action_container.set_process(false)
	_target_container.hide()
	_target_container.set_process(false)
	emit_signal("choose_action", action_type, card_type, _targets)

func _on_player_action(_action: Action) -> void:
	_action_container.hide()
	_action_container.set_process(false)

func _on_make_reaction(calling_action: Action, roles: Array) -> void:
	for child in $Respond_Actions.get_children():
		child.queue_free()
	
	if calling_action._sender_id == _id:
		return
	
	# Create PASS button
	_create_button("PASS", Action.ACTION_TYPE.PASS, 0, $Respond_Actions, "_on_respond_pressed", [Action.ACTION_TYPE.PASS, calling_action, 0])
	
	var actions: Array = []
	if calling_action._can_be_countered:
		actions.push_back(Action.ACTION_TYPE.COUNTER)
	if calling_action._can_be_doubted:
		actions.push_back(Action.ACTION_TYPE.DOUBT)
	
	for action_type in actions:
		if action_type == Action.ACTION_TYPE.COUNTER:
			for counter in Action.get_counters(calling_action.get_action_type()):
				if counter in roles:
					_create_button("%s with %s" % [Action.get_action_string(action_type), Card.get_card_name(counter)],
									action_type,
									counter,
									$Respond_Actions,
									"_on_respond_pressed",
									[action_type, calling_action, counter])
		else:
			_create_button(Action.get_action_string(action_type),
								action_type,
								0,
								$Respond_Actions,
								"_on_respond_pressed",
								[action_type, calling_action, 0])
	$Respond_Actions.show()
	$Respond_Actions.set_process(true)

func _on_respond_pressed(action_type: int, calling_action: Action, card_type: int) -> void:
	for child in $Respond_Actions.get_children():
		child.queue_free()
	emit_signal("reaction", action_type, calling_action, card_type)

func _on_end_reaction() -> void:
	_on_end_turn()

func _on_kill_card(card_id: int, card_type: int, is_alive: bool = true) -> void:
	$Cards.get_child(card_id).get_child(0).text = Card.get_card_name(card_type)
	if $Cards.get_child(card_id).color != Color("#000000"):
		$Cards.get_child(card_id).color = Color("#000000")
		$Cards.get_child(card_id).get_child(0).add_color_override("font_color", Color("#ffffff"))
		_alive_card -= 1
	if !is_alive:
		$Player_Badge.color = Color("#000000")
		$Player_Badge/Info/Spacer.text = "Dead"
	emit_signal("hand_updated")

func _on_wait_for_seconds(player: Player_Base, wait_time: float) -> void:
	_timer.one_shot = true
	_timer.wait_time = wait_time
	if !_timer.is_connected("timeout", player, "_on_resume_wait"):
		var _s = _timer.connect("timeout", player, "_on_resume_wait")
	_timer.start()

func _on_end_turn():
	hide_UI()

func _on_stop_reaction():
	hide_UI()

func hide_UI() -> void:
	for child in $Respond_Actions.get_children():
		child.queue_free()
	for child in _action_container.get_child(0).get_child(1).get_children():
		child.queue_free()
	for child in _action_container.get_child(1).get_child(1).get_children():
		child.queue_free()
	for child in _target_container.get_child(1).get_children():
		child.queue_free()
	for child in _card_select_container.get_child(1).get_children():
		child.queue_free()
	_action_container.hide()
	_action_container.set_process(false)
	_target_container.hide()
	_target_container.set_process(false)
	_card_select_container.hide()
	_card_select_container.set_process(false)
