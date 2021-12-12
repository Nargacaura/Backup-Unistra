extends TextureButton

export(Array, Texture) var cards_textures = []

signal choose_action(action_type, card_type, targets)
signal reaction(action_type, calling_action, card_type)
signal choose_cards(select)
signal choose_options(option)
signal hand_updated()
signal target_selected(target_id)


export(String) var username: String = "Username"
export(Color) var player_color = Color(0, 0, 0)
export(int, 0, 20) var default_balance = 0
export(String) var default_card_text = "?"

onready var player_face: Node = $Player_Face
onready var username_label: Node = $Username
onready var coin_badge_inner: Label = $Coin_Badge
onready var coin_badge_border: Label = $Coin_Badge/Border
onready var balance_text: Label = $Coin_Badge/Balance_Text

onready var cards_nodes: Array = $Cards.get_children()

var inner_color: Color = Color("#f2f2f2")
var border_color: Color

var _timer: Timer = null
var game_manager: Node = null
var _players_data: Dictionary
var _id: int
var _calling_action: Action = null
var is_bot: bool = false


func _ready():
	$Particles2D.emitting = false
	_timer = Timer.new()
	add_child(_timer)
	set_color(player_color)
	balance_text.text = str(default_balance)


func set_balance(amount: int) -> void:
	balance_text.text = str(amount)


func place_cards(positions: Array) -> void:
	cards_nodes[0].rect_position = positions[0]
	cards_nodes[1].rect_position = positions[1]


func set_card_text(card_index: int, text: String) -> void:
	cards_nodes[card_index].text = text


func set_username(name: String) -> void:
	username = name
	username_label.text = name

func set_color(color: Color) -> void:
	player_color = color
	update_color(player_color)
	$Particles2D.modulate = player_color
	
	for card in cards_nodes:
		card.get_node("Card_Text").text = default_card_text


func update_color(color: Color) -> void:
	self.self_modulate = color
	player_face.self_modulate = color
	username_label.add_color_override("font_color", color)
	var style_box: StyleBoxFlat = username_label.get("custom_styles/normal").duplicate()
	style_box.border_color = color
	username_label.set("custom_styles/normal", style_box)
	
	border_color = color
	coin_badge_inner.self_modulate = inner_color
	coin_badge_border.self_modulate = border_color
	balance_text.add_color_override("font_color", border_color)
	
	for card in cards_nodes:
		card.self_modulate = color


func _on_Player_mouse_entered():
	modulate = Color("#acacac")


func _on_Player_mouse_exited():
	modulate = Color("#ffffff")

################################################################################
# Core
################################################################################
func _on_action_pressed(action_type: int, card_type: int) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	game_manager.set_active_actions(false)
	game_manager.set_active_coup(false)
	var target_id: int = 0
	if Action.need_target(action_type):
		select_target(action_type)
		target_id = yield(self, "target_selected")
		if target_id == 0:
			if game_manager:
				game_manager.unlink_all_targets(self, "_on_target_pressed")
			return
	emit_signal("choose_action", action_type, card_type, [target_id])


func _on_target_pressed(target_id) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	if game_manager:
		game_manager.unlink_all_targets(self, "_on_target_pressed")
	emit_signal("target_selected", target_id)


func select_target(action_type: int) -> void:
	if game_manager and _id != game_manager._id:
		return
	for player_id in _players_data["alive"].keys():
		if player_id != _id:
			# Specific for CAPTAIN action
			if action_type == Action.ACTION_TYPE.CAPTAIN:
				if _players_data["alive"][player_id]["balance"] > 0:
					# Valid target for captain action
					# Link players button ont the map to "_on_target_selected"
					if game_manager:
						game_manager.link_target(self, "_on_target_pressed", player_id)
			# All other actions that need a target
			else:
				# Link players button ont the map to "_on_target_selected"
				if game_manager:
					game_manager.link_target(self, "_on_target_pressed", player_id)


func emit_particles(status: bool) -> void:
	$Particles2D.emitting = status


func _on_play_turn(player: Player, roles: Array, players_data: Dictionary) -> void:
	if players_data:
		_players_data = players_data
	if !game_manager:
		return
	
	update_cards(player.get_hand())
	var player_actions: Array = player.get_actions()
	
	if player.get_balance() >= 7:
		# Tell the game manager to enable COUP
		game_manager.set_active_coup(true)
	else:
		game_manager.set_active_coup(false)
	
	if player.get_balance() >= 10:
		# Tell the game manager to disable actions and bluffs
		game_manager.set_active_actions(false)
		return
	
	# Add buttons to UI
	for role in roles:
		match role:
			Card.CARD_TYPE.DUKE:
				game_manager.add_action_button(Action.ACTION_TYPE.DUKE, role, self, "_on_action_pressed", not role in player_actions)
			Card.CARD_TYPE.ASSASSIN:
				if player.get_balance() >= 3:
					game_manager.add_action_button(Action.ACTION_TYPE.ASSASSIN, role, self, "_on_action_pressed", not role in player_actions)
			Card.CARD_TYPE.CAPTAIN:
				game_manager.add_action_button(Action.ACTION_TYPE.CAPTAIN, role, self, "_on_action_pressed", not role in player_actions)
			Card.CARD_TYPE.AMBASSADOR:
				game_manager.add_action_button(Action.ACTION_TYPE.AMBASSADOR, role, self, "_on_action_pressed", not role in player_actions)
			Card.CARD_TYPE.INQUISITOR:
				game_manager.add_action_button(Action.ACTION_TYPE.INQUISITOR_1, role, self, "_on_action_pressed", not role in player_actions)
				game_manager.add_action_button(Action.ACTION_TYPE.INQUISITOR_2, role, self, "_on_action_pressed", not role in player_actions)
	
	game_manager.add_action_button(Action.ACTION_TYPE.FOREIGN_AID, Card.CARD_TYPE.HIDDEN, self, "_on_action_pressed", false)
	game_manager.add_action_button(Action.ACTION_TYPE.INCOME, Card.CARD_TYPE.HIDDEN, self, "_on_action_pressed", false)
	
	game_manager.set_active_actions(true)


func _on_reaction_pressed(action_type: int, card_type: int) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	game_manager.set_active_actions(false)
	game_manager.end_reaction_phase()
	emit_signal("reaction", action_type, _calling_action, card_type)


func _on_make_reaction(calling_action: Action, roles: Array, player: Player) -> void:
	_calling_action = calling_action
	game_manager.start_reaction_phase()
	
	var player_actions: Array = player.get_actions()
	
	var actions: Array = []
	if calling_action._can_be_countered:
		actions.push_back(Action.ACTION_TYPE.COUNTER)
	if calling_action._can_be_doubted:
		actions.push_back(Action.ACTION_TYPE.DOUBT)
	
	for action_type in actions:
		if action_type == Action.ACTION_TYPE.COUNTER:
			# Enable counter button
			game_manager.enable_counter()
			for counter in Action.get_counters(calling_action.get_action_type()):
				if counter in roles:
					game_manager.add_action_button(Action.ACTION_TYPE.COUNTER, counter, self, "_on_reaction_pressed", true, not counter in player_actions)
		else:
			game_manager.enable_doubt()


func _on_selected_card_validated(selected_card_indexes: Array) -> void:
	emit_signal("choose_cards", selected_card_indexes)


func _on_choose_cards(cards: Array, qty: int, text: String, select_type: int) -> void:
	if game_manager:
		game_manager.show_select_menu(cards, qty, text, select_type, self, "_on_selected_card_validated")
	else:
		var respond: Array = []
		for i in qty:
			respond.append(i)
		emit_signal("choose_cards", respond)


func _on_selected_option_validated(selected_card_indexes: Array) -> void:
	emit_signal("choose_options", selected_card_indexes)


func _on_choose_options(options: Array, text: String, card_type: int) -> void:
	if game_manager:
		game_manager.show_select_option_menu(options, text, card_type, self, "_on_selected_option_validated")
	else:
		emit_signal("choose_options", [randi() % options.size()])


func _on_add_card(card: Card, player_hand: Array) -> void:
	if card == null:
		return
	update_cards(player_hand)
	if game_manager and _id == game_manager._id:
		game_manager.add_card_to_view(card.get_name(), player_hand)
	emit_signal("hand_updated")


func _on_remove_card(card_index: int, player_hand: Array) -> void:
	if card_index >= cards_nodes.size():
		emit_signal("hand_updated")
		return
	update_cards(player_hand)
	if game_manager and _id == game_manager._id:
		game_manager.remove_card_from_view(card_index)
	emit_signal("hand_updated")


func _on_kill_card(card_index: int, _card_type: int, is_player_alive: bool = true, player_hand: Array = []) -> void:
	if card_index >= cards_nodes.size():
		emit_signal("hand_updated")
		return
	update_cards(player_hand)
	if game_manager and _id == game_manager._id:
		game_manager.kill_card_from_view(card_index)
		if !is_player_alive:
			game_manager.game_over(false)
	if !is_player_alive:
		update_color(Color(0, 0, 0))
	emit_signal("hand_updated")


func update_cards(player_hand: Array) -> void:
	var index: int = 0
	var is_dead: bool = false
	for card_node in cards_nodes:
		if index < player_hand.size() and (player_hand[index].is_dead() or _id == game_manager._id):
			if player_hand[index].get_type() <= Card.CARD_TYPE.HIDDEN or player_hand[index].get_type() >= Card.CARD_TYPE.INVALID:
				card_node.get_node("Card_Text").text = player_hand[index].get_name().left(2)
				card_node.get_node("Texture").texture = null
			else:
				card_node.get_node("Card_Text").text = ""
				card_node.get_node("Texture").texture = cards_textures[player_hand[index].get_type() - 1]
				
			is_dead = player_hand[index].is_dead()
		else:
			card_node.get_node("Card_Text").text = default_card_text
			is_dead = false
		set_card_style(card_node, is_dead)
		index += 1


func set_card_style(card_node: Node, is_dead) -> void:
	card_node.self_modulate = Color(0, 0, 0) if is_dead else player_color

func _on_init_player(player: Player_Base) -> void:
	if player:
		_id = player.get_id()
		set_username(player.get_username())


func _on_change_balance(balance: int) -> void:
	set_balance(balance)


func _on_player_action(_action: Action) -> void:
	if _id == game_manager._id:
		game_manager.clear_action_buttons()


func _on_end_turn():
	if _id == game_manager._id:
		game_manager.clear_action_buttons()
		game_manager.set_view_bluftimer()


func _on_end_reaction():
	if _id == game_manager._id:
		game_manager.clear_action_buttons()
		game_manager.end_reaction_phase()


func _on_stop_reaction():
	if _id == game_manager._id:
		game_manager.clear_action_buttons()
		game_manager.end_reaction_phase()


func _on_wait_for_seconds(player: Player_Base, wait_time: float) -> void:
	_timer.one_shot = true
	_timer.wait_time = wait_time
	if !_timer.is_connected("timeout", player, "_on_resume_wait"):
		var _s = _timer.connect("timeout", player, "_on_resume_wait")
	_timer.start()
