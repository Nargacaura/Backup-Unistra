extends Control

# Timer Nodes
onready var timer_label: Label = $Timer_Label

# Turn Nodes
onready var turn_container: Node = $Turn_Container
onready var turn_counter: Node = $Turn_Container/Turn_Counter
onready var turn_history_container: Node = $Turn_Container/Turn_History_Container/Turn_History
export(PackedScene) var Turn_Entry = null

# Balance Node
onready var balance_amount_node: Node = $Coin_Banner/CenterContainer/Balance/Amout

var _turn_count: int = 0
var game_manager: Node = null

var timer: Timer = null
var preivous_is_timer_low: bool = false
var is_timer_low: bool = false
var is_timer_low_color: bool = true
var timer_color: Color = Color("#2c2c54")
var low_timer_color: Color = Color("#ff0000")
var timer_flashing_rate: float = 0.5
var timer_flashing_rate_current_time: float = 0

var first_action_passed: bool = false

func _ready():
	set_turn_count(0)

func _process(delta):
	if timer:
		timer_label.text = get_formated_time_left(timer.time_left)
		if is_timer_low and preivous_is_timer_low != is_timer_low:
			toggle_low_timer_color()
		if is_timer_low:
			timer_flashing_rate_current_time += delta
			if timer_flashing_rate_current_time > timer_flashing_rate:
				toggle_low_timer_color()
				timer_flashing_rate_current_time = 0


func set_turn_count(turn_count: int) -> void:
	_turn_count = turn_count
	turn_counter.text = "%s %d" % [Localization.get("turn"), turn_count]


func add_action_history(action: Action, sender: Player_Base) -> void:
	var action_message: String = Action.get_action_string(action.get_action_type())
	if action.get_action_type() == Action.ACTION_TYPE.COUNTER:
		action_message = "Counter\nw/ %s" % Card.get_card_name(action.get_card_type())
	if action.get_action_type() == Action.ACTION_TYPE.CAPTAIN:
		action_message = "Take %d coins\nto %s" % [action.get_cost(), game_manager.board.get_player_by_id(action.get_targets_id()[0]).get_username()]
	
	if action_message != "" and action_message != "Invalid Action":
		add_history_entry(action_message, sender.get_color(), !first_action_passed)


func add_history_entry(message: String, player_color: Color, override_last: bool = false) -> void:
	if message != "" and message != "Invalid Action":
		if turn_history_container.get_child_count() > 0:
			var history_actions: Array = turn_history_container.get_children()
			history_actions[history_actions.size() - 1].set_last(false)
		
		if !override_last:
			var action_to_add: Node = Turn_Entry.instance()
			turn_history_container.add_child(action_to_add)
			action_to_add.set_action_text(message)
			action_to_add.set_player_color(player_color)
			action_to_add.set_last(true)
		else:
			first_action_passed = true
			var action_to_override: Node = turn_history_container.get_child(turn_history_container.get_child_count() - 1)
			action_to_override.set_action_text(message)
			action_to_override.set_player_color(player_color)
			action_to_override.set_last(true)

func clear_turn_history() -> void:
	for child in turn_history_container.get_children():
		child.free()


func set_balance(balance: int) -> void:
	balance_amount_node.text = str(balance)
	AudioManager.play_sfx(AudioManager.get_random_coin_sound())


func new_turn(active_player: Player_Base) -> void:
	first_action_passed = false
	set_turn_count(_turn_count + 1)
	clear_turn_history()
	if active_player:
		var message: String
		if not active_player is Bot:
			message = "It's your turn!"
		else:
			message = "%s is playing..." % [active_player.get_username()]
			
		add_history_entry(message, active_player.get_color())


func toggle_low_timer_color() -> void:
	set_timer_color(low_timer_color if is_timer_low_color else timer_color)
	is_timer_low_color = !is_timer_low_color


func set_timer_color(color: Color) -> void:
	timer_label.add_color_override("font_color", color)


func get_formated_time_left(time_left: float) -> String:
	preivous_is_timer_low = is_timer_low
	var minutes: int = int(ceil(time_left) / 60)
	var seconds: int = int(ceil(time_left)) % 60
	is_timer_low = minutes == 0 and seconds <= 5 and seconds > 0
	if minutes == 0 and seconds == 0:
		set_timer_color(timer_color)
	return "%02d:%02d" % [minutes, seconds]
