extends Node

signal update_user_data(user_data)

var user_data_path: String = "user://user_data.save"
var user_settings_path: String = "user://settings.save"

var username_prompt = preload("res://scenes/UsernamePrompt.tscn")
var main_menu: String = "res://scenes/MainMenu.tscn"
var game_scene: String = "res://scenes/game/Game.tscn"

var user_data: Dictionary = {}
var user_settings: Dictionary = {}

var player_count: int = 3
var use_ambassador: bool = true
var is_singleplayer: bool = true
var player_game_id: int = -1
var multiplayer_data: Dictionary = {}

enum SectionRow {
	TEXT,
	SLIDER,
	TOGGLE,
}

var players_colors = [
	Color("#39b54a"),
	Color("#29abe2"),
	Color("#b33939"),
	Color("#d9e021"),
	Color("#f7931e"),
	Color("#2c2c54"),
	Color("#c69c6d"),
	Color("#93278f")
]

var root = null

#####################################
# DEBUG VARS TO REMOVE
var force_default_data: bool = false
#####################################
var COMPUTER_BUILD: bool = true


func _ready():
	root = get_tree().get_root()
	load_user_data(force_default_data)
	load_user_settings(force_default_data)
	display_username_prompt()


func display_username_prompt() -> void:
	if user_data["login"]["username"] == "":
		var prompt = username_prompt.instance()
		root.get_child(root.get_child_count() - 1).add_child(prompt)


func set_username(username: String) -> void:
	user_data["login"]["username"] = username
	save_user_data()
	emit_signal("update_user_data", user_data)


################################################################################
# SAVE SYSTEM
################################################################################
func load_user_data(force_default: bool = false) -> void:
	var data_file = File.new()
	# If file doesn't exist, load default settings and save them
	if force_default or not data_file.file_exists(user_data_path):
		user_data = get_default_user_data()
		save_user_data()
		return
		
	data_file.open(user_data_path, File.READ)
	user_data = parse_json(data_file.get_line())
	data_file.close()


func save_user_data() -> void:
	var data_file = File.new()
	if data_file.open(user_data_path, File.WRITE) == OK:
		data_file.store_line(to_json(user_data))
		data_file.close()


func get_default_user_data() -> Dictionary:
	return {
		"login": {
			"username": "",
			"hash": "",
		},
		"game-config": {
			"player_count": 3,
			"bot_difficulty": Bot.BOT_DIFFICULTY.EASY,
			"use_ambassador": true,
		},
		"sec-global-achievements": {
			"title": "achievements",
			"order": 0,
			"values": {
				"total_game_count": {"order": 0, "title": "achievement.veteran", "desc": "achievement.veteran.desc", "value": [0, 300]},
				"total_win_count": {"order": 1, "title": "achievement.champion", "desc": "achievement.champion.desc", "value": [0, 100]},
				"total_coin_count": {"order": 2, "title": "achievement.gold_for_days", "desc": "achievement.gold_for_days.desc", "value": [0, 1000]},
				"total_coup_count": {"order": 3, "title": "achievement.execution", "desc": "achievement.execution.desc", "value": [0, 250]},
				"total_successful_counter_count": {"order": 4, "title": "achievement.nope", "desc": "achievement.nope.desc", "value": [0, 500]},
				"total_successful_doubt_count": {"order": 5, "title": "achievement.mentalist", "desc": "achievement.mentalist.desc", "value": [0, 500]},
				"total_successful_lie_count": {"order": 6, "title": "achievement.great_liar", "desc": "achievement.great_liar.desc", "value": [0, 500]},
			},
		},
		"sec-character-achievements": {
			"title": "menu.rules.characters",
			"order": 1,
			"values": {
				"assassin": {"order": 0, "title": "achievement.assassin", "desc": "achievement.assassin.desc", "value": [0, 100]},
				"captain": {"order": 1, "title": "achievement.captain", "desc": "achievement.captain.desc", "value": [0, 100]},
				"duke": {"order": 2, "title": "achievement.duke", "desc": "achievement.duke.desc", "value": [0, 100]},
				"contessa": {"order": 3, "title": "achievement.contessa", "desc": "achievement.contessa.desc", "value": [0, 100]},
				"ambassador": {"order": 4, "title": "achievement.ambassador", "desc": "achievement.ambassador.desc", "value": [0, 100]},
				"inquisitor_1": {"order": 5, "title": "achievement.inquisitor_swap", "desc": "achievement.inquisitor_swap.desc", "value": [0, 50]},
				"inquisitor_2": {"order": 6, "title": "achievement.inquisitor_look", "desc": "achievement.inquisitor_look.desc", "value": [0, 50]},
			},
		},
	}


func load_user_settings(force_default: bool = false) -> void:
	var settings_file = File.new()
	# If file doesn't exist, load default settings and save them
	if force_default or not settings_file.file_exists(user_settings_path):
		user_settings = get_default_user_settings()
		save_user_settings()
		return
		
	settings_file.open(user_settings_path, File.READ)
	user_settings = parse_json(settings_file.get_line())
	settings_file.close()


func save_user_settings() -> void:
	var save_settings = File.new()
	if save_settings.open(user_settings_path, File.WRITE) == OK:
		save_settings.store_line(to_json(user_settings))
		save_settings.close()


func get_default_user_settings() -> Dictionary:
	return {
		"sec-volume": {
			"title": "Volume",
			"order": 1,
			"values": {
				"master": {"order": 0, "title": "Master", "row_type": SectionRow.SLIDER, "value": 50},
				"music":  {"order": 1, "title": "Music", "row_type": SectionRow.SLIDER, "value": 100},
				"sfx": {"order": 2, "title": "Sounds", "row_type": SectionRow.SLIDER, "value": 100},
			},
		},
		"sec-options": {
			"title": "Options",
			"order": 2,
			"values": {
				"lang": {"order": 0, "title": "Language", "row_type": SectionRow.TEXT, "value": Localization.LANG.en_US},
			},
		},
	}
