extends VBoxContainer

signal back(previous_content, node_self)
onready var back_btn: Button = $PageTitle/Button
var previous_content = null

onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var player_count_minus_btn: Button = $Grid/Top/LeftColumn/PlayerCount/Buttons/Minus
onready var player_count_plus_btn: Button = $Grid/Top/LeftColumn/PlayerCount/Buttons/Plus
onready var ambassador_btn: Button = $Grid/Top/CenterColumn/Ambassador/Button
onready var inquisitor_btn: Button = $Grid/Top/CenterColumn/Inquisitor/Button
onready var bot_difficulty_btn: Button = $Grid/Bottom/BotDifficulty/Button
onready var play_btn: Button = $Grid/Bottom/Play/Button

onready var player_count_label: Label = $Grid/Top/LeftColumn/PlayerCount/Content/ItemContainer/Label
onready var bot_difficulty_label: Label = $Grid/Bottom/BotDifficulty/Content/ItemContainer/Label


export(String, FILE) var game_scene = "res://scenes/game/Game.tscn"
var player_count: int = true setget set_player_count
var use_ambassador: bool = true setget set_use_ambassador
var bot_difficulty: int = Bot.BOT_DIFFICULTY.EASY setget set_bot_difficulty
var _ret # To Stop Warnings


func _ready():
	_ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	# Fetch game configs
	set_player_count(AppManager.user_data["game-config"]["player_count"])
	set_use_ambassador(AppManager.user_data["game-config"]["use_ambassador"])
	set_bot_difficulty(AppManager.user_data["game-config"]["bot_difficulty"])
	
	# Navigation button
	_ret = back_btn.connect("pressed", self, "_on_Back_pressed")
	
	# Game Config buttons
	_ret = player_count_plus_btn.connect("pressed", self, "_on_PlayerCount_changed", [1])
	_ret = player_count_minus_btn.connect("pressed", self, "_on_PlayerCount_changed", [-1])
	_ret = ambassador_btn.connect("pressed", self, "_on_Choice_changed", [true])
	_ret = inquisitor_btn.connect("pressed", self, "_on_Choice_changed", [false])
	_ret = bot_difficulty_btn.connect("pressed", self, "_on_BotDifficulty_changed")
	_ret = play_btn.connect("pressed", self, "_on_PlayButton_pressed")
	_ret = play_btn.connect("mouse_entered", self, "_on_PlayButton_hover", [true])
	_ret = play_btn.connect("mouse_exited", self, "_on_PlayButton_hover", [false])
	_on_window_resize()


func _on_window_resize() -> void:
	if get_viewport_rect().size[0] > get_viewport_rect().size[1]:
		$Grid.columns = 2
		$Grid/Bottom.columns = 1
	else:
		$Grid.columns = 1
		$Grid/Bottom.columns = 2


func hide_menu() -> void:
	animation_player.play("hide")
	set_process(false)


func show_menu() -> void:
	AppManager.is_singleplayer = true
	set_process(true)
	animation_player.play("show")


func _on_Back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	emit_signal("back", previous_content, self)


func _on_PlayerCount_changed(increment: int) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	set_player_count(player_count + increment)


func _on_Choice_changed(_use_ambassador: bool) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	set_use_ambassador(_use_ambassador)


func _on_BotDifficulty_changed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	set_bot_difficulty(bot_difficulty + 1)


func _on_PlayButton_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	AppManager.user_data["game-config"]["player_count"] = player_count
	AppManager.user_data["game-config"]["use_ambassador"] = use_ambassador
	AppManager.user_data["game-config"]["bot_difficulty"] = bot_difficulty
	AppManager.save_user_data()
	AppManager.player_game_id = 1
	AppManager.is_singleplayer = true
	if game_scene:
		Loader.load_scene(game_scene)


func _on_PlayButton_hover(is_hover: bool) -> void:
	if is_hover:
		play_btn.get_parent().modulate = Color(0.6, 0.6, 0.6)
	else:
		play_btn.get_parent().modulate = Color(1, 1, 1)


func set_player_count(amount: int) -> void:
	player_count = amount
	player_count = int(max(2, player_count))
	player_count = int(min(8, player_count))
	player_count_label.text = str(player_count)


func set_use_ambassador(status: bool) -> void:
	use_ambassador = status
	if use_ambassador:
		ambassador_btn.pressed = true
		inquisitor_btn.pressed = false
	else:
		ambassador_btn.pressed = false
		inquisitor_btn.pressed = true


func set_bot_difficulty(difficulty: int) -> void:
	bot_difficulty = difficulty
	if bot_difficulty < Bot.BOT_DIFFICULTY.EASY:
		bot_difficulty = Bot.BOT_DIFFICULTY.HARD
	if bot_difficulty > Bot.BOT_DIFFICULTY.HARD:
		bot_difficulty = Bot.BOT_DIFFICULTY.EASY
	bot_difficulty_label.text = Bot.get_difficulty_str(bot_difficulty)
